//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 25.04.2023.
//

import Foundation

//struct Res: Decodable {
//   let results: [PhotoResult]
//}
struct PhotoResult: Decodable {
    let id: String
    let width: Int
    let height: Int
    let createdAt: String?
    let description: String?
    let urls: PhotoSize
    let likedByUser: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case createdAt = "created_at"
        case description
        case urls
        case likedByUser = "liked_by_user"
    }
    
}

struct PhotoSize: Decodable {
    let thumb: String
    let regular: String
}

struct LikePhotoResult:Decodable {
    let photo: PhotoResult
}
