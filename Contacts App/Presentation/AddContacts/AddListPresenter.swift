import UIKit

protocol AddListController: AnyObject {
    
    var collectionWidth: CGFloat {get}
    
    func showAlert()
    func setupData(data: [ViewModel])
}

enum Constants {
    static let height = CGFloat(40)
}

class AddListPresenter {
    
    weak var view: AddListController?
    private var contact: Contact
    
    init(contact: Contact? = nil) {
        self.contact = contact ?? .init(
            name: "",
            surname: "",
            middleName: "",
            phone: "",
            email: "",
            date: "",
            sex: "",
            notes: ""
        )
    }
    
    private var saveHieght: CGFloat = 0
    
    // MARK: - ValidationCheck
    static func validatedPhone(phoneExamination: String) -> Bool {
        let phone = phoneExamination.trimmingCharacters(in: CharacterSet.whitespaces)
        let regex = "(([+]+[7])|[8])+[0-9]{10}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: phone)
        return result
    }
    
    static func validatedEmail(emailExamination: String) -> Bool {
        let email = emailExamination.trimmingCharacters(in: CharacterSet.whitespaces)
        let regex = "[A-Z0-9a-z.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: email)
        return result
    }
    
    static func validatedName(nameExamination: String) -> Bool {
        let name = nameExamination.trimmingCharacters(in: CharacterSet.whitespaces)
        let regex = "[A-Za-z]{1,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: name)
        return result
    }
    
    static func validatedSurname(surnameExamination: String) -> Bool {
        let surname = surnameExamination.trimmingCharacters(in: CharacterSet.whitespaces)
        let regex = "[A-Za-z]{1,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: surname)
        return result
    }
    
    private func validatePhone() -> Bool {
        var isValid = false
        isValid = AddListPresenter.validatedPhone(phoneExamination: contact.phone)
        return isValid
     }
     
     private func validateEmail() -> Bool {
         var isValid = false
         isValid = AddListPresenter.validatedEmail(emailExamination: contact.email)
         return isValid
     }
     
     private func validateName() -> Bool {
         var isValid = false
         isValid = AddListPresenter.validatedName(nameExamination: contact.name)
         return isValid
     }
     
     private func validateSurname() -> Bool {
         var isValid = false
         isValid = AddListPresenter.validatedSurname(surnameExamination: contact.surname)
         return isValid
     }
    
    func calculateNotesHeight() -> CGFloat {
        let height = contact.notes.heightWithConstrainedWidth(
            width: (view?.collectionWidth ?? 0) - NotesTextcollectionView.horizontalSpasing,
            font: .systemFont(ofSize: 15)
        )
        return height + NotesTextcollectionView.verticalSpacing
    }
    
    func createColorForElements(contactRes: Bool) -> UIColor {
        var color: UIColor
        if contactRes == false {
            color = Resources.Colors.informationFalse
        } else {
            color = Resources.Colors.informationTrue
        }
        return color
    }
    
    // MARK: - CreateForm
    func createForm() {
        let width = view?.collectionWidth ?? .zero
        let dataSource: [ViewModel] = [
            .init(cellType: .name,
                  viewModel: TextInputViewModel(
                    text: contact.name,
                    placeHolder: "name",
                    errorColor: createColorForElements(contactRes:
                                                        AddListPresenter.validatedName(nameExamination:
                                                                                        contact.name))
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .surname,
                  viewModel: TextInputViewModel(
                    text: contact.surname,
                    placeHolder: "surname",
                    errorColor: createColorForElements(contactRes:
                                                        AddListPresenter.validatedSurname(surnameExamination:
                                                                                            contact.surname))
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .middleName,
                  viewModel: TextInputViewModel(
                    text: contact.middleName,
                    placeHolder: "middle name"
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .phone,
                  viewModel: TextInputViewModel(
                    text: contact.phone,
                    placeHolder: "phone",
                    errorColor: createColorForElements(contactRes:
                                                        AddListPresenter.validatedPhone(phoneExamination:
                                                                                            contact.phone))
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .email,
                  viewModel: TextInputViewModel(
                    text: contact.email,
                    placeHolder: "email",
                    errorColor: createColorForElements(contactRes:
                                                        AddListPresenter.validatedEmail(emailExamination:
                                                                                            contact.email))
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .date,
                  viewModel: DatePickerTextInputViewModel(text: contact.date, placeHolder: "date"),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .sex,
                  viewModel: ViewPickerTextInputViewModel(text: contact.sex, placeholder: "sex"),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .notes,
                  viewModel: NotesTextInputViewModel(text: contact.notes),
                  cellSize: .init(width: width, height: calculateNotesHeight()))
            ]
        view?.setupData(data: dataSource)
    }
    
    func textSave(cellType: DetailCellType, text: String) {
        switch cellType {
        case .name:
            contact.name = text
        case .surname:
            contact.surname = text
        case .middleName:
            contact.middleName = text
        case .phone:
            contact.phone = text
        case .email:
            contact.email = text
        case .date:
            contact.date = text
        case .sex:
            contact.sex = text
        case .notes:
            contact.notes = text
        }
    }

    func dateFormatter(datePicker: Date) -> String {
        let date = datePicker
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    func save() {

        let isValidPhone = validatePhone()
        let isValidEmail = validateEmail()
        let isValidateName = validateName()
        let isValidSurname = validateSurname()
        if (!isValidPhone || !isValidEmail || !isValidSurname || !isValidateName) == true {
            createForm()
            view?.showAlert()
        } else {
            print(ContactCreate.init(name: contact.name,
                                     surname: contact.surname,
                                     middleName: contact.middleName,
                                     phone: contact.phone,
                                     date: contact.date,
                                     sex: contact.sex,
                                     email: contact.email,
                                     notes: contact.notes))
        }
    }
}

private typealias TextInputViewModel = TextFieldCollectionViewCell.ViewModel
private typealias DatePickerTextInputViewModel = DatePickerCollectionViewCell.ViewModel
private typealias ViewPickerTextInputViewModel = SexPickerCollectionViewCell.ViewModel
private typealias NotesTextInputViewModel = NotesTextcollectionView.ViewModel
