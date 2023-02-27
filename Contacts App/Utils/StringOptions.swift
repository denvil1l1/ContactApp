//
//  StringOptions.swift
//  Contacts App
//
//  Created by vladislav on 14.11.2022.
//

import UIKit

extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(
            width: width,
            height: .greatestFiniteMagnitude
        )
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return ceil(boundingBox.height)
    }
    
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
        let regex = "[A-Z0-9a-zА-Яа-я]{1,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: name)
        return result
    }
    
    static func validatedSurname(surnameExamination: String) -> Bool {
        let surname = surnameExamination.trimmingCharacters(in: CharacterSet.whitespaces)
        let regex = "[A-Z0-9a-zА-Яа-я]{1,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let result = predicate.evaluate(with: surname)
        return result
    }
    
}
