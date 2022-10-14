struct Contact {
    var name: String
    var surname: String
    var phone: String
    var email: String
    static func generalContacts() -> [Contact] {
        var contact = [Contact(name: "Alex", surname: "Chrome", phone: "89289636616", email: "vlad@mail.ru"), Contact(name: "Alex2", surname: "Chrome", phone: "89289636616", email: "vlad@mail.ru"), Contact(name: "Alex3", surname: "Chrome", phone: "89289636616", email: "vlad@mail.ru"), Contact(name: "Alex4", surname: "Chrome", phone: "89289636616", email: "vlad@mail.ru"), Contact(name: "Alex5", surname: "Chrome", phone: "89289636616", email: "vlad@mail.ru")]
        return (contact)
    }
}
