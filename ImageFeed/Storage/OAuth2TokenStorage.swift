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
         //   KeychainWrapper.standard.string(forKey: "token")
            UserDefaults.standard.string(forKey: "token")
        }
        set {
            guard let newValue else { return }
           // KeychainWrapper.standard.set(newValue, forKey: "token")
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    func removeToken() {
        guard let token else { return }
       // KeychainWrapper.standard.removeObject(forKey: token)
        UserDefaults.standard.removeObject(forKey: "token")
    }
}
