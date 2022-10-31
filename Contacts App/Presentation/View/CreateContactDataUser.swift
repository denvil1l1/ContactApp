import Foundation

struct ViewModel {
    
    var cellType: DetailCellType
    var viewModel: Any
    var cellSize: CGSize
}

enum DetailCellType {
    
    case name
    case surname
    case middleName
    case date
    case sex
    case phone
    case email
    case notes
}

struct ContactCreate {
    
    var name: String
    var surname: String
    var middleName: String
    var phone: String
    var date: Int
    var sex: String
    var email: String
    var notes: String
}
