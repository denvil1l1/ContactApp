import UIKit

protocol AddContactPresenterDelegate: AnyObject {
    
    func onAddContactSave(index: Int?, contact: Contact, state: AddContactState)
}

protocol AddPresenter: AnyObject {
    
    var collectionWidth: CGFloat { get }
    
    func setupData(data: [ViewModel])
}

enum Constants {
    static let height = CGFloat(40)
}

class AddContactPresenter {
    private let contactListPresenter: ContactListPresenter
    weak var delegate: AddContactPresenterDelegate?
    weak var view: AddContactController?
    private var contact: Contact
    init(contact: Contact? = nil, contactListPresenter: ContactListPresenter) {
        self.contactListPresenter = contactListPresenter
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
    private var arrayFirstTextRun = ["phone": true,
                                     "email": true,
                                     "name": true,
                                     "date": true,
                                     "surname": true,
                                     "sex": true
    ]
    
    func validateArray() -> [String: Bool] {
        let arrayValidate = ["phone": String.validatedPhone(phoneExamination: contact.phone),
                             "name": String.validatedName(nameExamination: contact.name),
                             "email": String.validatedEmail(emailExamination: contact.email),
                             "surname": String.validatedSurname(surnameExamination: contact.surname)
        ]
        return arrayValidate
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private func validateAll(name: String) -> (UIColor, Bool) {
        var color = UIColor()
        var chek: Bool
        if arrayFirstTextRun[name] ?? false || validateArray()[name] ?? true {
            color = Resources.Colors.informationTrue
            arrayFirstTextRun[name] = false
            chek = true
        } else {
            color = Resources.Colors.informationFalse
            chek = false
        }
        return (color, chek)
    }
    
    private func validateOptional() -> UIColor {
        return Resources.Colors.informationTrue
    }
    
    private func validateDate() -> (UIColor, Bool) {
            var color: UIColor
            var chek: Bool
            if contact.date != nil || arrayFirstTextRun["date"] ?? false {
                arrayFirstTextRun["date"] = false
                color = Resources.Colors.informationTrue
                chek = true
            } else {
                color = Resources.Colors.informationFalse
                chek = false
            }
            return (color, chek)
        }
        
    private func validateSex() -> (UIColor, Bool) {
        var color: UIColor
        var chek: Bool
        if contact.sex != nil || arrayFirstTextRun["sex"] ?? false {
            arrayFirstTextRun["sex"] = false
            color = Resources.Colors.informationTrue
            chek = true
        } else {
            color = Resources.Colors.informationFalse
            chek = false
        }
        return (color, chek)
    }

    func calculateNotesHeight() -> CGFloat {
        let height = contact.notes?.heightWithConstrainedWidth(
            width: (view?.collectionWidth ?? 0) - TextViewCell.horizontalSpasing,
            font: .systemFont(ofSize: 15)
        ) ?? CGFloat()
        return height + TextViewCell.verticalSpacing
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
                    errorColor: validateAll(name: "name").0
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .surname,
                  viewModel: TextInputViewModel(
                    text: contact.surname,
                    placeHolder: "surname",
                    errorColor: validateAll(name: "surname").0
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .middleName,
                  viewModel: TextInputViewModel(
                    text: contact.middleName,
                    placeHolder: "middle name",
                    errorColor: validateOptional()
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .phone,
                  viewModel: TextInputViewModel(
                    text: contact.phone,
                    placeHolder: "phone",
                    errorColor: validateAll(name: "phone").0
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .email,
                  viewModel: TextInputViewModel(
                    text: contact.email,
                    placeHolder: "email",
                    errorColor: validateAll(name: "email").0
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .date,
                  viewModel: DatePickerViewModel(text: dateString(for: contact.date), placeHolder: "date", errorColor: validateDate().0),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .sex,
                  viewModel: SexPickerViewModel(text: contact.sex?.displayRowValue, placeholder: "sex", pickerData: VariantsSex.allCases.map({ $0.displayRowValue }), errorColor: validateSex().0),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .notes, viewModel: TextViewModel(text: contact.notes ?? "", placeholder: "notes", errorColor: validateOptional()),
                  cellSize: .init(width: width, height: calculateNotesHeight()))
            
        ]
        view?.setupData(with: dataSource)
    }
    
    func edit(indexPath: Int, startModel: Contact?) -> Bool {
        if validateBeforeSaving() {
            return true
        } else {
            createForm()
            return false
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
    
    func dateString(for date: Date?) -> String? {
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func chekChanges(index: Int, contact: Contact?) {
        if self.contact.name != contact?.name
        {
            view?.showAlert()
        } else {
            view?.saveAndEditContact()
        }
    }

    func validateBeforeSaving() -> Bool {
        if validateAll(name: "name").1 && validateAll(name: "surname").1 && validateAll(name: "phone").1 && validateAll(name: "email").1 && validateDate().1 && validateSex().1 {
            return true
        } else {
            return false
        }
    }
    
    func save(index: Int? = nil, state: AddContactState, contact: Contact?) {
        if validateBeforeSaving() {
        delegate?.onAddContactSave(index: index, contact: self.contact, state: view?.state ?? .edit)
        } else {
            createForm()
        }
    }
}
private typealias TextInputViewModel = TextFieldCell.ViewModel
private typealias DatePickerViewModel = DatePickerCell.ViewModel
private typealias SexPickerViewModel = PickerCell.ViewModel
private typealias TextViewModel = TextViewCell.ViewModel
