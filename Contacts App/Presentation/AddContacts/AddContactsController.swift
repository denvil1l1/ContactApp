import UIKit

enum State {
    case edit
    case create
}

class AddContactsController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let alertOk = "OK"
        static let alertNo = "No"
        static let alertYes = "Yes"
        static let alertQuestion = "It seems you made a mistake"
        static let navigationTitleCreate = "Create"
        static let navigationTitleEdit = "Edit"
    }
    
    var index: Int
    
    // MARK: - AddPresenter
    var presenter: AddListPresenter?
    
    class func instantiate(model: Contact? = nil, state: State, indexPath: Int? = nil) -> UIViewController {
        let vc = AddContactsController(state: state, index: indexPath ?? 1)//
        let presenter = AddListPresenter(contact: model)
        vc.presenter = presenter
        presenter.view = vc
        return vc
    }
    
    init(state: State, index: Int) {
        self.state = state
        self.index = index//
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AllVarAndLET
    var dataSourse: [ViewModel] = []
    
    var state: State = .create
    
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
        var titleButton: UIBarButtonItem.SystemItem
        switch state {
        case .edit:
            navigationItem.title = Constants.navigationTitleEdit
            titleButton = .edit
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: titleButton,
                target: self,
                action: #selector(onAddTapEdit) )
        case .create:
            navigationItem.title = Constants.navigationTitleCreate
            titleButton = .save
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: titleButton,
                target: self,
                action: #selector(onAddTapCreate) )
        }
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
    func onAddTapEdit() {
        let alertController = UIAlertController(title: Constants.alertQuestion,
                                                message: nil,
                                                preferredStyle: .alert)
        let actionOk = UIAlertAction(title: Constants.alertYes, style: .default) { _ in
            self.presenter?.edit(indexPath: self.index)
            self.navigationController?.popViewController(animated: true)
        }
        let actionNo = UIAlertAction(title: Constants.alertNo, style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(actionOk)
        alertController.addAction(actionNo)
        self.present(alertController, animated: true)
    }
    
    @objc
    func collectionViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func onAddTapCreate() {
        if presenter?.save() == true {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

// MARK: - AddListInputDelegate
extension AddContactsController: AddListViewInput {
    
    func setupData(with cellDataArray: ([ViewModel])) {
        self.dataSourse = cellDataArray
        collectionView.reloadData()
    }
    
}

// MARK: - CollectionViewDataSource
extension AddContactsController: UICollectionViewDataSource {
    
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
extension AddContactsController: AddPresenter {
    
    var collectionWidth: CGFloat {
        view.bounds.width
    }
    
    func setupData(data: [ViewModel]) {
        dataSourse = data
        collectionView.reloadData()
    }
    
}

// MARK: - Extansion
extension AddContactsController: PickerCellDelegate {
    
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

extension AddContactsController: TextFieldCellDelegate {
    
    func onTextEdit(text: String, cell: UICollectionViewCell) {
        
        if let indexPath = collectionView.indexPath(for: cell) {
            if var viewModel = dataSourse[indexPath.item].viewModel as? TextFieldCell.ViewModel {
                viewModel.text = text
                dataSourse[indexPath.item].viewModel = viewModel
            }
            presenter?.textSave(cellType: dataSourse[indexPath.item].cellType, text: text)
        }
        
    }
    
    func showAlert() {
        
        let alertController = UIAlertController(title: Constants.alertQuestion,
                                                message: nil,
                                                preferredStyle: .alert)
        let actionOk = UIAlertAction(title: Constants.alertOk, style: .default) { _ in }
        alertController.addAction(actionOk)
        self.present(alertController, animated: true)
    }
    
}

extension AddContactsController: DatePickerCellDelegate {
    
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

extension AddContactsController: TextViewCellDelegate {
    
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

extension AddContactsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return dataSourse[indexPath.item].cellSize
    }
    
}
