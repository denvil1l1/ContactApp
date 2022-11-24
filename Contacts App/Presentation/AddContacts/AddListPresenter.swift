import UIKit

protocol AddListViewInput: AnyObject {
    
    var collectionWidth: CGFloat { get }
    
    func showAlert()
    func setupData(data: [ViewModel])
}

enum Constants {
    static let height = CGFloat(40)
}

class AddListPresenter {
    
    weak var view: AddListViewInput?
    private var contact: Contact
    
    init(contact: Contact? = nil) {
        self.contact = contact ?? .init(
            name: "",
            surname: "",
            middleName: "",
            phone: "",
            email: "",
            date: nil,
            sex: .none,
            notes: ""
        )
    }
    
    private var saveHieght: CGFloat = 0

    private func validatePhone() -> Bool {
        var isValid = false
        isValid = String.validatedPhone(phoneExamination: contact.phone)
        return isValid
     }
     
     private func validateEmail() -> Bool {
         var isValid = false
         isValid = String.validatedEmail(emailExamination: contact.email)
         return isValid
     }
     
     private func validateName() -> Bool {
         var isValid = false
         isValid = String.validatedName(nameExamination: contact.name)
         return isValid
     }
     
     private func validateSurname() -> Bool {
         var isValid = false
         isValid = String.validatedSurname(surnameExamination: contact.surname)
         return isValid
     }
    
    func calculateNotesHeight() -> CGFloat {
        let height = contact.notes.heightWithConstrainedWidth(
            width: (view?.collectionWidth ?? 0) - TextViewCell.horizontalSpasing,
            font: .systemFont(ofSize: 15)
        )
        return height + TextViewCell.verticalSpacing
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
    
    func enumTextCreate (at: Int) -> String? {
        VariantsSex(rawValue: at)?.displayRowValue
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
                                                        String.validatedName(nameExamination:
                                                                                        contact.name))
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .surname,
                  viewModel: TextInputViewModel(
                    text: contact.surname,
                    placeHolder: "surname",
                    errorColor: createColorForElements(contactRes:
                                                        String.validatedSurname(surnameExamination:
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
                                                        String.validatedPhone(phoneExamination:
                                                                                            contact.phone))
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .email,
                  viewModel: TextInputViewModel(
                    text: contact.email,
                    placeHolder: "email",
                    errorColor: createColorForElements(contactRes:
                                                        String.validatedEmail(emailExamination:
                                                                                            contact.email))
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .date,
                  viewModel: DatePickerViewModel(text: dateString(for: contact.date), placeHolder: "date"),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .sex,
                  viewModel: SexPickerViewModel(text: contact.sex?.displayRowValue, placeholder: "sex", pickerData: VariantsSex.allCases.map({ $0.displayRowValue })),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .notes, viewModel: TextViewModel(text: contact.notes, placeholder: "notes"),
                  cellSize: .init(width: width, height: calculateNotesHeight()))
           
            ]
        view?.setupData(data: dataSource)
    }
    
    func pickerSave(text: VariantsSex, cellType: DetailCellType) {
        switch cellType {
        case .sex:
            contact.sex = text
        default:
            break
        }
    }
    
    func dateSave (cellType: DetailCellType, date: Date) {
        switch cellType {
        case .date:
            contact.date = date
        default:
            break
        }
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
        case .notes:
            contact.notes = text
        default:
            break
        }
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    func dateString(for date: Date?) -> String? {
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func save() {

        let isValidPhone = validatePhone()
        let isValidEmail = validateEmail()
        let isValidateName = validateName()
        let isValidSurname = validateSurname()
        if !isValidPhone || !isValidEmail || !isValidSurname || !isValidateName {
            createForm()
            view?.showAlert()
            print(contact.sex)
        } else {
        }
    }
}

private typealias TextInputViewModel = TextFieldCollectionViewCell.ViewModel
private typealias DatePickerViewModel = DatePickerCollectionViewCell.ViewModel
private typealias SexPickerViewModel = PickerCollectionViewCell.ViewModel
private typealias TextViewModel = TextViewCell.ViewModel
