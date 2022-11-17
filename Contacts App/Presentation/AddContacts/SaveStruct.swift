//
//  SaveStruct.swift
//  Contacts App
//
//  Created by vladislav on 14.11.2022.
//
import Foundation
import UIKit
final class SaveContact {
    
    private enum SettingsKeys: String {
        case userName
    }
    
    static var userName: String! {
        get {
            return UserDefaults.standard.string(forKey: SettingsKeys.userName.rawValue)
        } set {
            
            let defaults = UserDefaults.standard
            let key = SettingsKeys.userName.rawValue
            if let name = newValue {
                defaults.set(name, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
            }
        }
    }
}
