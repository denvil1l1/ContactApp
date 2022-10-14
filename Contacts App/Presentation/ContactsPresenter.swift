import Foundation

class Presenter {
    weak private var viewInputDelegate: ViewInputDelegate?
    var testData = Contact.generateContact()
}
