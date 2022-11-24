import UIKit

class AddContactsController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let alertOk = "OK"
        static let alertQuestion = "It seems you made a mistake"
        static let navigationTitle = "Create"
    }
    
    // MARK: - AddPresenter
    var presenter: AddListPresenter?
    
    class func instantiate() -> UIViewController {
        let vc = AddContactsController()
        let presenter = AddListPresenter()
        vc.presenter = presenter
        presenter.view = vc
        return vc
    }
    
    // MARK: - AllVarAndLET
    var dataSourse: [ViewModel] = []
    
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(onAddTap)
        )
        navigationItem.title = Constants.navigationTitle
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
    func collectionViewTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc
    func onAddTap() {
        presenter?.save()
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

extension UICollectionView {
    
    func registerAnyCell<T: UICollectionViewCell>(_ cellClass: T.Type) {
        register(cellClass.self, forCellWithReuseIdentifier: String(describing: cellClass))
      }
  
    func dequeueReusableCell<CellClass: UICollectionViewCell>(of type: CellClass.Type, for indexPath: IndexPath) -> CellClass {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: type.self), for: indexPath) as? CellClass else {
          fatalError("could not cast UICollectionViewCell at indexPath (section: \(indexPath.section), row: \(indexPath.row)) to expected type \(String(describing: CellClass.self))")
        }
        return cell
      }
    
}
