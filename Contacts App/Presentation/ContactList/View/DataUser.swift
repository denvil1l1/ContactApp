import Foundation

struct Contact {
    
    var id: String = UUID().uuidString
    var name: String
    var surname: String
    var middleName: String
    var phone: String
    var email: String
    var date: Date?
    var sex: VariantsSex?
    var notes: String?
}

enum CodingKeys: String, CodingKey {
    case name
    case surname
    case middleName
    case phone
    case email
    case date
    case sex
    case notes
}

extension Contact: Codable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(middleName, forKey: .middleName)
        try container.encode(phone, forKey: .phone)
        try container.encode(email, forKey: .email)
        try container.encode(date, forKey: .date)
        if let sex = sex?.rawValue {
            try container.encode(sex, forKey: .sex)
        }
        try container.encode(notes, forKey: .notes)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        middleName = try container.decode(String.self, forKey: .middleName)
        phone = try container.decode(String.self, forKey: .phone)
        email = try container.decode(String.self, forKey: .email)
        date = try container.decode(Date.self, forKey: .date)
        if let sexInt = try? container.decode(Int.self, forKey: .sex) {
            sex = VariantsSex(rawValue: sexInt)
        }
        notes = try? container.decodeIfPresent(String.self, forKey: .notes)
    }
}
        
