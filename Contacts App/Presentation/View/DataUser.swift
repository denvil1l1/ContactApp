struct Contact {
    var name: String
    var surname: String
    var phone: String
    var email: String
}
extension Contact {
    static func generateContact() -> [Contact] {
        let contact = [Contact (name: "Alex", surname: "Petrov", phone: "89289636616", email: "letme"), Contact(name: "Dima", surname: "Komarov", phone: "89289636616", email: "letme"), Contact(name: "Vlad", surname: "Smirnov", phone: "89289636616", email: "letme"), Contact(name: "Petr", surname: "Covrov", phone: "89289636616", email: "letme"), Contact(name: "Maria", surname: "Soldatenko", phone: "89289636616", email: "letme")]
        return contact
    }
}
