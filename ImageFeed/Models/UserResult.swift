//
//  UserResult.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 12.04.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: [String: String]
    
    enum CodingKeys: String, CodingKey{
        case profileImage = "profile_image"
    }
}
