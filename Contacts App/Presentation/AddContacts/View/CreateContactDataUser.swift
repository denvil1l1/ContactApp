import Foundation
import UIKit

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
    var date: String
    var sex: String
    var email: String
    var notes: String
}

enum VariantsSex: Int, CaseIterable {
    case man
    case woman
    case none
    
    var displayRowValue: String {
        switch self {
        case .man:
            return "Man"
        case .woman:
           return "Woman"
        case .none:
            return "Nothing"
        }
    }
}
