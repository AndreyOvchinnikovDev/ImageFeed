//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 02.04.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: "token")
        }
        set {
            guard let newValue else { return }
            KeychainWrapper.standard.set(newValue, forKey: "token")
        }
    }
    
    func deleteToken() {
        KeychainWrapper.standard.removeObject(forKey: "token")
    }
}
