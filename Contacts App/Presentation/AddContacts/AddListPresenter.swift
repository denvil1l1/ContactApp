import UIKit

protocol AddPresenter: AnyObject {
    
    var collectionWidth: CGFloat { get }
    
    func setupData(data: [ViewModel])
}

enum Constants {
    static let height = CGFloat(40)
}

class AddListPresenter {
    
    weak var view: AddContactsController?
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
    private var arrayFirstTextRun = Array(repeating: true, count: 6)
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    private func validatePhone() -> (UIColor, Bool) {
        var color = UIColor()
        var chek: Bool
        if arrayFirstTextRun[0] || String.validatedPhone(phoneExamination: contact.phone) {
            color = Resources.Colors.informationTrue
            arrayFirstTextRun[0] = false
            chek = true
        } else {
            color = Resources.Colors.informationFalse
            chek = false
        }
        return (color, chek)
    }
    
    private func validateEmail() -> (UIColor, Bool) {
        var color = UIColor()
        var chek: Bool
        if arrayFirstTextRun[2] || String.validatedEmail(emailExamination: contact.email) {
            color = Resources.Colors.informationTrue
            arrayFirstTextRun[2] = false
            chek = true
        } else {
            color = Resources.Colors.informationFalse
            chek = false
        }
        return (color, chek)
    }
    
    private func validateName() -> (UIColor, Bool) {
        var color = UIColor()
        var chek: Bool
        if arrayFirstTextRun[1] || String.validatedName(nameExamination: contact.name) {
            color = Resources.Colors.informationTrue
            arrayFirstTextRun[1] = false
            chek = true
        } else {
            color = Resources.Colors.informationFalse
            chek = false
        }
        return (color, chek)
    }
    
    private func validateSurname() -> (UIColor, Bool) {
        var color = UIColor()
        var chek: Bool
        if arrayFirstTextRun[3] || String.validatedSurname(surnameExamination: contact.surname) {
            color = Resources.Colors.informationTrue
            arrayFirstTextRun[3] = false
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
        if contact.date != nil || arrayFirstTextRun[4] {
            arrayFirstTextRun[4] = false
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
        if contact.sex != nil || arrayFirstTextRun[5] {
            arrayFirstTextRun[5] = false
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
                    errorColor: validateName().0
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .surname,
                  viewModel: TextInputViewModel(
                    text: contact.surname,
                    placeHolder: "surname",
                    errorColor: validateSurname().0
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
                    errorColor: validatePhone().0
                  ),
                  cellSize: .init(width: width, height: Constants.height)),
            .init(cellType: .email,
                  viewModel: TextInputViewModel(
                    text: contact.email,
                    placeHolder: "email",
                    errorColor: validateEmail().0
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
    
    func edit(indexPath: Int) -> Bool {
        if finalChek() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
            if let data = try? encoder.encode(contact) {
                let defaults = UserDefaults.standard
                var arrayData = defaults.object(forKey: "contacts") as? [Data]
                if arrayData?[indexPath] == data {
                } else {
                    arrayData?[indexPath] = data
                    defaults.set(arrayData, forKey: "contacts")
                }
            }
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
    
    func dateString(for date: Date?) -> String? {
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return nil
    }

    func finalChek() -> Bool {
        if validateName().1 && validatePhone().1 && validateEmail().1 && validateSurname().1 && validateDate().1 && validateSex().1 {
            return true
        } else {
            return false
        }
    }
    
    func save() -> Bool {
        if finalChek() {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            if let data = try? encoder.encode(contact) {
                let defaults = UserDefaults.standard
                var arrayData = [Data]()
                if let userDefaultsData = defaults.object(forKey: "contacts") as? [Data] {
                    arrayData += userDefaultsData
                }
                arrayData.append(data)
                defaults.set(arrayData, forKey: "contacts")
                return true
            }
        } else {
            createForm()
            return false
        }
        return false
    }
}

private typealias TextInputViewModel = TextFieldCell.ViewModel
private typealias DatePickerViewModel = DatePickerCell.ViewModel
private typealias SexPickerViewModel = PickerCell.ViewModel
private typealias TextViewModel = TextViewCell.ViewModel
