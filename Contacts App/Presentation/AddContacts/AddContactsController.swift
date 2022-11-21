import UIKit

class AddContactsController: UIViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let textField = "nameTextCell"
        static let datePicker = "datePicker"
        static let pickerView = "pickerView"
        static let textViewNotes = "textViewNotes"
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
        collectionView.register(TextFieldCollectionViewCell.self, forCellWithReuseIdentifier: Constants.textField)
        collectionView.register(DatePickerCollectionViewCell.self, forCellWithReuseIdentifier: Constants.datePicker)
        collectionView.register(PickerCollectionViewCell.self, forCellWithReuseIdentifier: Constants.pickerView)
        collectionView.register(NotesTextcollectionView.self, forCellWithReuseIdentifier: Constants.textViewNotes)
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
            barButtonSystemItem: .save, target: self, action: #selector(onAddTap))
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
        self.presenter?.save()
    }
}

// MARK: - AddListInputDelegate
extension AddContactsController: AddListInputDelegate {
    
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.textField, for: indexPath)
            if let viewModel = cellItem.viewModel as? TextFieldCollectionViewCell.ViewModel,
               let cell = cell as? TextFieldCollectionViewCell {
                cell.delegate = self
                cell.configure(with: viewModel)
            }
            return cell
        case .date:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.datePicker, for: indexPath)
            if let viewModel = cellItem.viewModel as? DatePickerCollectionViewCell.ViewModel,
               let cell = cell as? DatePickerCollectionViewCell {
                cell.delegate = self
                cell.configure(with: viewModel)
            }
            return cell
        case .sex:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.pickerView, for: indexPath)
            if let viewModel = cellItem.viewModel as? PickerCollectionViewCell.ViewModel,
               let cell = cell as? PickerCollectionViewCell {
                cell.delegate = self
                cell.configure(with: viewModel)
            }
            return cell
        case .notes:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.textViewNotes, for: indexPath)
            if let viewModel = cellItem.viewModel as? NotesTextcollectionView.ViewModel,
               let cell = cell as? NotesTextcollectionView {
                cell.delegate = self
                cell.configure(with: viewModel)
            }
            return cell
        }
    }
}

// MARK: OnDelegateAddListDelegate
extension AddContactsController: AddListController {
    
    var collectionWidth: CGFloat {
        
        return view.bounds.width
    }
    
    func  setupData(data: [ViewModel]) {
        
        dataSourse = data
        collectionView.reloadData()
    }
}

// MARK: - Extansion
extension AddContactsController: PickerCellDelegate {
    func sexPickerCellSave(sexPicker: VariantsSex) {
        presenter?.enumSave(sexPicker: sexPicker, cellType: .sex)
    }
}

extension AddContactsController: TextViewCellDelegate {
    
    func onTextEdit(text: String, cell: UICollectionViewCell) {
        
        if let indexPath = collectionView.indexPath(for: cell) {
            if var viewModel = dataSourse[indexPath.item].viewModel as? TextFieldCollectionViewCell.ViewModel {
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

extension AddContactsController: DatePickerCollectionViewCellDelegate {
    func datePickerCellDateChanged(date: Date) {
        presenter?.dateSave(cellType: .date, date: date)
    }
    
    func datePickerCellConvertDate(dateOnPicker: Date) -> String {
        return (presenter?.dateFormatter(datePicker: dateOnPicker) ?? "")
    }
    
}

extension AddContactsController: NotesTextCollectionViewDelegate {
    func notesTextCellChanged(text: String, cell: UICollectionViewCell) {
        presenter?.textSave(cellType: .notes, text: text)
        
        if let indexPath = collectionView.indexPath(for: cell) {
            let oldHeight = dataSourse[indexPath.item].cellSize.height
            let newHeight = presenter?.calculateNotesHeight() ?? .zero
            dataSourse[indexPath.item].cellSize.height = newHeight
            if var viewModel = dataSourse[indexPath.item].viewModel as? NotesTextcollectionView.ViewModel {
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
