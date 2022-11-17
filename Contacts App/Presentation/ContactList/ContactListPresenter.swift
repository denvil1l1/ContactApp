import Foundation

final class ContactListPresenter {
    
    weak var view: ViewInputDelegate?
    
    // For UserDefaults
    let defaults = UserDefaults.standard
    let nameContact = "contacts"
    var contacts: [Contact] {
        get {
            if let data = defaults.value(forKey: nameContact) as? Data,
               let contacts = try? JSONDecoder().decode([Contact].self, from: data) {
                    return contacts
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
