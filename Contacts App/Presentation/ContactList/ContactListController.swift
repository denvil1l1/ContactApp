import UIKit

private enum Constants {
    static let trash = "trash"
    static let identifier = "MyCell"
    static let search = "Search"
    static let heightForRowAt = 50
    static let trashColor = UIColor(red: 48/255, green: 194/255, blue: 208/255, alpha: 1.0)
    static let aletNo = "No"
    static let aletYes = "Yes"
}

class ContactListController: UIViewController {
    
    // MARK: - AddPresenter
    var presenter: ContactListPresenter?
    
    class func instantiate() -> UIViewController {
        let vc = ContactListController()
        let presenter = ContactListPresenter()
        vc.presenter = presenter
        presenter.view = vc
        return vc
    }
    var dataSourse: [String] = []
    
    // MARK: - TableViewConfiguration
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - ConfigureSearchController
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.search
        navigationItem.searchController = searchController
        definesPresentationContext = true
        return searchController
    }()
    
    //MARK: - OvverideFunc
    override func viewDidLoad() {
        super.viewDidLoad()
        layoytTableView()
        configureNavigationBar()
        presenter?.viewisready()
    }
    
    //MARK: - NavigationBar
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self, action: #selector(onAddTap))
        navigationItem.title = "Contacts"
        navigationItem.searchController = searchController
    }
    
    func layoytTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // MARK: - ButtonForNewController
    @objc func onAddTap () {
        let vc = AddContactsController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ContactListController: ViewInputDelegate {
    
    func setupData(with arrayContactsController: ([String])) {
        self.dataSourse = arrayContactsController
        tableView.reloadData()
    }
    
}

//MARK: Add function for delete Rows (swipe left)
extension ContactListController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trashAction = UIContextualAction(style: .normal, title:  "", handler: {  [unowned self] _, _, completed in
            let aletController = UIAlertController(title: "Do you want to delete this contact ? ", message: "", preferredStyle: .alert)
            
            let actionYes = UIAlertAction(title: Constants.aletYes, style: .default) { (actionYes) in
                self.dataSourse.remove(at: indexPath.row)
                self.presenter?.remove(indexPath: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
            let actionNo = UIAlertAction(title: Constants.aletNo, style: .default) { (actionNo) in completed(true)}
            aletController.addAction(actionYes)
            aletController.addAction(actionNo)
            self.present(aletController, animated: true)
        })
        trashAction.image = UIImage(systemName: Constants.trash)
        trashAction.image?.withTintColor(Constants.trashColor)
        trashAction.backgroundColor = UIColor.red
        return UISwipeActionsConfiguration(actions: [trashAction])
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifier, for: indexPath)
        let name =  dataSourse[indexPath.row]
        cell.textLabel?.text = name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(Constants.heightForRowAt)
    }
    
}

extension ContactListController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.search(searchText: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter?.search(searchText: "")
    }
}
