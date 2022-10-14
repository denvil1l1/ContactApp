import UIKit

class ContactListController: UIViewController {
    
    //Create var and constants=================================================================
    var myTableView = UITableView()
    let identifire = "MyCell"
    var userInformation = Contact.generateContact()
    var total = 0
    //Create UISerchController=================================================================
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        //Use function==========================================================================
        title = "Bar Items"
        createTable()
        configureNavigationBar()
    }
    //MARK: Add navigation bar==================================================================
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .add, target: self, action: #selector(onAddTap))
        navigationItem.title = "Contacts"
    }
    //MARK: Create table view==================================================================
    func createTable() {
        self.myTableView = UITableView(frame: view.bounds, style: .plain)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        myTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(myTableView)
    }
    
    //Target for button add
    @objc func onAddTap () {
        print("123")
    }
}

extension ContactListController: UITableViewDelegate, UITableViewDataSource, ViewInputDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        <#code#>
    }
    func setupData(with testData: ([Contact])) {
        
    }
    //MARK: - UITableViewDataSource
       func tableView(_ tableView: UITableView, numberOfRowsInSecn section: Int) -> Int {
           return userInformation.count
       }
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return userInformation.count
       }
       //MARK: - UITableViewDataSource
       func tableView (_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
       
       func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
           print("Accesory path =", indexPath)
           
           let ounerCell = tableView.cellForRow(at: indexPath)
           print("Cell tittle =", ounerCell?.textLabel?.text ?? "nil")
       }
        //Out data in table
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
           let name = userInformation[indexPath.row]
           cell.textLabel?.text = name.name + " " + name.surname
           return cell
    }
        
}
