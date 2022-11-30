import Foundation

final class ContactListPresenter {
    
    weak var view: ContactListViewInput?
    
    // For UserDefaults
    let defaults = UserDefaults.standard
    let nameContact = "contact"
    var contacts: [Contact] {
        get {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            var temp = [Contact]()
            if let data = defaults.object(forKey: "contacts") as? [Data] {
                
                data.forEach { item in
                    if let contact = try? decoder.decode(Contact.self, from: item) {
                        temp.append(contact)
                    }
                }
                return temp
            }
            return []
        } set {
            if let data = try? JSONEncoder().encode(newValue) {
                defaults.set(data, forKey: nameContact)
            }
        }
    }
    
    // MARK: saveContact func
    func saveContact(contact: Contact) {
        contacts.insert(contact, at: 0)
    }
    
    // MARK: ViewISReady func
    func viewisready() {
        let arrayContactsController = contacts.map { $0.name + " " + $0.surname }
        view?.setupData(with: arrayContactsController)
    }
    
    // MARK: DeleteForSwipe func
    func remove(indexPath: Int) {
        contacts.remove(at: indexPath)
    }
    
    // MARK: SerchAndFiltered func
    func search(searchText: String) {
        let trimmedText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedText.isEmpty {
            let testData = contacts.map { $0.name + " " + $0.surname }
            view?.setupData(with: testData)
            return
        }
        let testData = contacts
            .filter {
                $0.name.lowercased().contains(trimmedText.lowercased()) ||
                $0.surname.lowercased().contains(trimmedText.lowercased())
            }
            .map { $0.name + " " + $0.surname }
        view?.setupData(with: testData)
    }
    
}
