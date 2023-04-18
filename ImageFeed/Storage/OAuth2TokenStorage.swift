//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 02.04.2023.
//

import Foundation
import SwiftKeychainWrapper

class OAuth2TokenStorage {
    var token: String {
        get {
            KeychainWrapper.standard.string(forKey: "token") ?? ""
        }
        set {
            KeychainWrapper.standard.set(newValue, forKey: "token")
        }
    }
}
