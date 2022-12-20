import UIKit

enum AddContactState {
    case edit
    case create
}

class AddContactController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let alertOk = "OK"
        static let alertNo = "No"
        static let alertYes = "Yes"
        static let alertQuestion = "Do you want to save your changes?"
        static let navigationTitleCreate = "Create"
        static let navigationTitleEdit = "Edit"
    }
    
    var index: Int
    var createValue: Contact?
    
    // MARK: - AddPresenter
    var presenter: AddContactPresenter?
    
    class func instantiate(model: Contact? = nil, state: AddContactState, indexPath: Int? = nil) -> UIViewController {
        let vc = AddContactController(state: state, index: indexPath ?? 1, model: model)
        let delegate = ContactListPresenter()
        let presenter = AddContactPresenter(contact: model, contactListPresenter: delegate)
        vc.presenter = presenter
        presenter.view = vc
        presenter.delegate = delegate
        return vc
    }
    
    init(state: AddContactState, index: Int, model: Contact? = nil) {
        self.state = state
        self.index = index
        self.createValue = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AllVarAndLET
    var dataSourse: [ViewModel] = []
    
    var state: AddContactState = .create
    
    // MARK: - UICollectionView
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.registerAnyCell(TextFieldCell.self)
        collectionView.registerAnyCell(PickerCell.self)
        collectionView.registerAnyCell(DatePickerCell.self)
        collectionView.registerAnyCell(TextViewCell.self)
        return collectionView
    }()
    
    func layoutCollectionView () {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            view.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor)
        ])
    }
    
    // MARK: - CnfigureNavigationBar
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
                                                            target: self,
                                                            action: #selector(saveAndEditContact))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(saveAndEditBack))
        
    }
    
    func notificationCenter() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillHideNotification,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(adjustForKeyboard),
                                       name: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil)
    }
    
    // MARK: - CollectionViewCreate
    override func viewDidLoad() {
        super.viewDidLoad()
        setTapGestureRecognizer()
        configureNavigationBar()
        presenter?.createForm()
        notificationCenter()
        layoutCollectionView()
    }
    
    // MARK: - setTapGestureRecognized
    func setTapGestureRecognizer() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(collectionViewTapped)))
    }
    
    // MARK: - Targets
    @objc
    func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            collectionView.contentInset = .zero
        } else {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height
                                                       - view.safeAreaInsets.bottom, right: 0)
        }
        
        collectionView.scrollIndicatorInsets = collectionView.contentInset
    }
    
    @objc
    func saveAndEditContact() {
        presenter?.save(index: self.index, state: state, contact: createValue)
        if presenter?.validateBeforeSaving() == true {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    @objc
    func collectionViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func saveAndEditBack() {
        presenter?.chekChanges(index: index, contact: createValue)
    }
    @objc
    func showAlert() {
        let aletController = UIAlertController(title: Constants.alertQuestion,
                                               message: "",
                                               preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: Constants.alertYes, style: .default) { [unowned self]_ in
            presenter?.save(index: self.index, state: state, contact: createValue)
            if presenter?.validateBeforeSaving() == true {
                _ = navigationController?.popViewController(animated: true)
            }
        }
        let actionNo = UIAlertAction(title: Constants.alertNo, style: .default) { [unowned self]_ in
            _ = navigationController?.popViewController(animated: true)
        }
        aletController.addAction(actionYes)
        aletController.addAction(actionNo)
        self.present(aletController, animated: true)
    }
}

// MARK: - AddListInputDelegate
extension AddContactController: AddListViewInput {
    
    func setupData(with cellDataArray: ([ViewModel])) {
        self.dataSourse = cellDataArray
        collectionView.reloadData()
    }
    
}

// MARK: - CollectionViewDataSource
extension AddContactController: UICollectionViewDataSource {
    
    // MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSourse.count
    }
    
    // MARK: - collectionView
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellItem = dataSourse[indexPath.item]
        switch cellItem.cellType {
        case .middleName, .name, .email, .phone, .surname:
            let cell = collectionView.dequeueReusableCell(of: TextFieldCell.self, for: indexPath)
            if let viewModel = cellItem.viewModel as? TextFieldCell.ViewModel {
                cell.delegate = self
                cell.configure(with: viewModel)
            }
            return cell
        case .date:
            let cell = collectionView.dequeueReusableCell(of: DatePickerCell.self, for: indexPath)
            if let viewModel = cellItem.viewModel as? DatePickerCell.ViewModel {
                cell.delegate = self
                cell.configure(with: viewModel)
            }
            return cell
        case .sex:
            let cell = collectionView.dequeueReusableCell(of: PickerCell.self, for: indexPath)
            if let viewModel = cellItem.viewModel as? PickerCell.ViewModel {
                cell.delegate = self
                cell.configure(with: viewModel)
            }
            return cell
        case .notes:
            let cell = collectionView.dequeueReusableCell(of: TextViewCell.self, for: indexPath)
            if let viewModel = cellItem.viewModel as? TextViewCell.ViewModel {
                cell.delegate = self
                cell.configure(with: viewModel)
            }
            return cell
        }
    }
    
}

// MARK: OnDelegateAddListDelegate
extension AddContactController: AddPresenter {

    var collectionWidth: CGFloat {
        view.bounds.width
    }
    
    func setupData(data: [ViewModel]) {
        dataSourse = data
        collectionView.reloadData()
    }
    
}

// MARK: - Extansion
extension AddContactController: PickerCellDelegate {
    
    func pickerText(at: Int) -> String? {
        presenter?.enumTextCreate(at: at)
    }
    
    func pickerRowSelected(at: Int, cell: UICollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            if var viewModel = dataSourse[indexPath.item].viewModel as? PickerCell.ViewModel {
                let cellType = dataSourse[indexPath.item].cellType
                switch cellType {
                case .sex:
                    let sex = VariantsSex(rawValue: at)
                    viewModel.text = sex?.displayRowValue ?? ""
                    presenter?.pickerSave(text: sex ?? .none, cellType: cellType)
                default:
                    break
                }
                dataSourse[indexPath.item].viewModel = viewModel
            }
        }
    }
    
}

extension AddContactController: TextFieldCellDelegate {
    
    func onTextEdit(text: String, cell: UICollectionViewCell) {
        
        if let indexPath = collectionView.indexPath(for: cell) {
            if var viewModel = dataSourse[indexPath.item].viewModel as? TextFieldCell.ViewModel {
                viewModel.text = text
                dataSourse[indexPath.item].viewModel = viewModel
            }
            presenter?.textSave(cellType: dataSourse[indexPath.item].cellType, text: text)
        }
        
    }
    
}

extension AddContactController: DatePickerCellDelegate {
    
    func datePickerCellDateChanged(date: Date, row: UICollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: row) {
            if var viewModel = dataSourse[indexPath.item].viewModel as? DatePickerCell.ViewModel {
                viewModel.text = datePickerCellConvertDate(dateOnPicker: date)
                dataSourse[indexPath.item].viewModel = viewModel
            }
            presenter?.dateSave(cellType: .date, date: date)
            print(date)
        }
    }
    
    func datePickerCellConvertDate(dateOnPicker: Date) -> String? {
        return presenter?.dateString(for: dateOnPicker)
    }
    
}

extension AddContactController: TextViewCellDelegate {
    
    func notesTextCellChanged(text: String, cell: UICollectionViewCell) {
        presenter?.textSave(cellType: .notes, text: text)
        if let indexPath = collectionView.indexPath(for: cell) {
            let oldHeight = dataSourse[indexPath.item].cellSize.height
            let newHeight = presenter?.calculateNotesHeight() ?? .zero
            dataSourse[indexPath.item].cellSize.height = newHeight
            if var viewModel = dataSourse[indexPath.item].viewModel as? TextViewCell.ViewModel {
                viewModel.text = text
                dataSourse[indexPath.item].viewModel = viewModel
            }
            if oldHeight != newHeight {
                collectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
}

extension AddContactController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dataSourse[indexPath.item].cellSize
    }
    
}
