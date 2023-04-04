//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 02.04.2023.
//

import Foundation

class OAuth2TokenStorage {
    var token: String {
        get {
            UserDefaults.standard.string(forKey: "token") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
}
