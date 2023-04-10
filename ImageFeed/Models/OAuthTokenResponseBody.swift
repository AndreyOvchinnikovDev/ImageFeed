//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 02.04.2023.
//

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}
