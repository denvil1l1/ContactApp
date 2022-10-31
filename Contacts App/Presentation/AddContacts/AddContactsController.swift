import UIKit

class AddContactsController: UIViewController {
    private enum Constants {
        
        static let textField = "nameTextCell"

    }
    
    //MARK: AddPresenter
    var presenter: AddListPresenter!
    
    //MARK: - AllVarAndLET
    var dataSourse: [ViewModel] = []
    var collectionView: UICollectionView!
    
    //MARK: UICollectionViewFlowLayout
    private var layout : UICollectionViewFlowLayout {
        
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let boundSize: CGSize = UIScreen.main.bounds.size
        layout.itemSize = CGSize(width: boundSize.width, height: 40)
        return layout
    }
    
    //MARK: - CnfigureNavigationBar
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save, target: self, action: #selector(onAddTap))
        navigationItem.title = "Create"
    }
    
    //MARK: - CollectionViewCreate
    override func viewDidLoad() {
        configureNavigationBar()
        presenter = AddListPresenter()
        presenter.view = self
        presenter.createForm()
        
        self.collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: self.layout)
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.dataSource = self
        self.collectionView.register(TextFieldCollectionViewCell.self, forCellWithReuseIdentifier: Constants.textField)
        self.collectionView.reloadData()
        self.view.addSubview(collectionView)
    }
    
    @objc
    func onAddTap() {
        let alertController = UIAlertController(title: "Do you want to save this contact ? ", message: "", preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "YES", style: .default) { (actionYes) in }
        let actionNo = UIAlertAction(title: "NO", style: .default) { (actionNo) in _ = self.navigationController?.popViewController(animated: true)}
        alertController.addAction(actionYes)
        alertController.addAction(actionNo)
        self.present(alertController, animated: true)
    }
}

//MARK: - AddListInputDelegate
extension AddContactsController:  AddListInputDelegate {
    func setupData(with cellDataArray: ([ViewModel])) {
        self.dataSourse = cellDataArray
        
    }
}

//MARK: - CollectionViewDataSource
extension AddContactsController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSourse.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellItem = dataSourse[indexPath.item]
        switch cellItem.cellType {
        case .middleName, .name, .email, .phone, .surname:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.textField, for: indexPath)
            if let viewModel = cellItem.viewModel as? TextFieldCollectionViewCell.ViewModel, let cell = cell as? TextFieldCollectionViewCell {
                cell.configure(with: viewModel)
            }
            return cell
            //        case .date:
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.datePickerCell, for: indexPath)
            //                return cell
            //        case .sex:
            //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.sexPickerCell, for: indexPath)
            //                return cell
        default:
            return .init()
        }
    }
}

//MARK: OnDelegateAddListDelegate
extension AddContactsController: AddListDelegate {
    
    func  setupData(data: [ViewModel]) {
        
        dataSourse = data
        collectionView.reloadData()
    }
}


//case .name:
//    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.nameTextCell, for: indexPath) as? TextFieldCollectionViewCell else {return UICollectionViewCell()}
//    cell.configure(model: cellItem)
//    return cell
//case .surname:
//    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.datePickerCell, for: indexPath)
//    return cell
