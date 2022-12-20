import Foundation
final class ContactListPresenter {
    weak var view: ContactListViewInput?
    // For UserDefaults
    let defaults = UserDefaults.standard
    let nameContact = "contacts"
    var contacts: [Contact] {
        get {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let data = defaults.value(forKey: "contacts" ) as? Data,
               let contacts = try? decoder.decode([Contact].self, from: data) {
                return contacts
            }
            return[]
        }
        set {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            if let data = try? encoder.encode(newValue) {
                defaults.set(data, forKey: "contacts")
            }
        }
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

extension ContactListPresenter: AddContactPresenterDelegate {
    
    func onAddContactEdit(contact: Contact) {
        
    }
    
    func onAddContactSave(index: Int? = nil, contact: Contact, state: AddContactState) {
        switch state {
        case .create:
            contacts.append(contact)
        case .edit:
            if let index {
                contacts[index] = contact
            }
        }
    }
    
}
