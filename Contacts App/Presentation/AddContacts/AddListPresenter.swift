import UIKit
protocol AddListDelegate: AnyObject {
    func  setupData(data: [ViewModel])
}

class AddListPresenter {

   weak var view: AddListInputDelegate?
    private var contact: Contact
    init(contact: Contact? = nil) {
        self.contact = contact ?? .init(name: "", surname: "")
    }
    
    func createForm() {
        let dataSource: [ViewModel] = [
            .init(cellType: .name, viewModel: TextInputViewModel(text: contact.name, placeHolder: "name"), cellSize: .init(width: 40, height: 40)),
            .init(cellType: .email, viewModel: TextInputViewModel(text: "", placeHolder: "surname"), cellSize: .init(width: 40, height: 40)),
            .init(cellType: .middleName, viewModel: TextInputViewModel(text: "", placeHolder: "middle name"), cellSize: .init(width: 40, height: 40)),
            .init(cellType: .phone, viewModel: TextInputViewModel(text: "", placeHolder: "phone"), cellSize: .init(width: 40, height: 40)),
            .init(cellType: .surname, viewModel: TextInputViewModel(text: "", placeHolder: "email"), cellSize: .init(width: 40, height: 40))
        ]
        view?.setupData(with: dataSource)
    }
}

private typealias TextInputViewModel = TextFieldCollectionViewCell.ViewModel
