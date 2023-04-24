//
//  UserResult.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 12.04.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey{
        case profileImage = "profile_image"
    }
}
struct ProfileImage: Decodable {
    let small, medium, large: String
}
