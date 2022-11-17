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
    
    // MARK: - AllVarAndLET
    var dataSourse: [ViewModel] = []
    
    // MARK: - UICollectionView
    private lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TextFieldCollectionViewCell.self, forCellWithReuseIdentifier: Constants.textField)
        collectionView.register(DatePickerCollectionViewCell.self, forCellWithReuseIdentifier: Constants.datePicker)
        collectionView.register(SexPickerCollectionViewCell.self, forCellWithReuseIdentifier: Constants.pickerView)
        collectionView.register(NotesTextcollectionView.self, forCellWithReuseIdentifier: Constants.textViewNotes)
        view.addSubview(collectionView)
        return collectionView
    }()
    
    // MARK: CollectionViewlayout
    private var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let boundSize: CGSize = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width: boundSize.width, height: 45)
        return layout
    }
    
    // MARK: - CnfigureNavigationBar
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(onAddTap))
        navigationItem.title = Constants.navigationTitle
    }
 
    // MARK: - CollectionViewCreate
    override func viewDidLoad() {
        super.viewDidLoad()
        setTapGestureRecognizer()
        configureNavigationBar()
        presenter = AddListPresenter()
        presenter?.view = self
        presenter?.createForm()
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
            if let viewModel = cellItem.viewModel as? SexPickerCollectionViewCell.ViewModel,
               let cell = cell as? SexPickerCollectionViewCell {
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
extension AddContactsController: SexPickerCollectionDelegate {
    func saveSex(sexNumber: String) {
        presenter?.textSave(cellType: .sex, text: sexNumber)
    }
}
extension AddContactsController: InputCollectionCellDelegate {
    
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

extension AddContactsController: ChangeDatePickerValueDelegate {
    func convertDate(dateOnPicker: Date) -> String {
        return (presenter?.dateFormatter(datePicker: dateOnPicker))!
    }
    
    func datePickerChanged(text: String) {
        presenter?.textSave(cellType: .date, text: text)
    }
}

extension AddContactsController: InputCollectionCellSizeDelegate {
    func inputInTextView(text: String, cell: UICollectionViewCell) {
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
