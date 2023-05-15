//
//  Constants.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 27.03.2023.
//

import Foundation

class Constants {
    static let accessKey = "bq_QqwO1Dz_fd5LubzuJNtkiMi1NP0-vzyPjAZeEeKY"
    static let secretKey = "7-e6BfGa0IfriPIU8Pqx_y8Um-_5RGaIvrr5I6ZYg00"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
    static let authURLString = "https://unsplash.com/oauth/authorize"
    static let urlToGetToken = "https://unsplash.com/oauth/token"
}

struct AuthConfiguration {
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: Constants.authURLString,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 urlToGetToken: Constants.urlToGetToken)
    }
    
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    let urlToGetToken: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL, urlToGetToken: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.urlToGetToken = urlToGetToken
    }
}
