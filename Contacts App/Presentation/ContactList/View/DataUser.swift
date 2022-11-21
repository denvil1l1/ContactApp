import Foundation

struct Contact: Codable {
    
    var name: String
    var surname: String
    var middleName: String
    var phone: String
    var email: String
    var date: Date?
    var sex: VariantsSex?
    var notes: String
}
