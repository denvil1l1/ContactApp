import UIKit
struct UserInformation {
    var name:String
    var surname:String
    var phone:String
    var email:String
}

class ContactListController: UIViewController {
    var myTableView = UITableView()
    let identifire = "MyCell"
    //Создаем массив структур
    var userInformation = [UserInformation(name: "Alex", surname: "Chrome", phone: "89289636616", email: "vlad@mail.ru") ]
    var total = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        createTable()
        navigationController?.navigationBar
    }
    func createTable() {
        self.myTableView = UITableView(frame: view.bounds, style: .plain)
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: identifire)
        self.myTableView.delegate = self
        self.myTableView.dataSource = self
        myTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        view.addSubview(myTableView)
    }
}

extension ContactListController: UITableViewDelegate, UITableViewDataSource {
    //MARK: - UITableViewDataSource
       func tableView(_ tableView: UITableView, numberOfRowsInSecn section: Int) -> Int {
           return userInformation.count
       }
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return userInformation.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: identifire, for: indexPath)
           let name = userInformation[indexPath.row]
           cell.textLabel?.text = name.name + " " + name.surname
           return cell
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
}
