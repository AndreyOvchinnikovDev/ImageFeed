//
//  File.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 25.04.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    static let dateFormatter = ISO8601DateFormatter()
    
    static func createPhoto(photo: PhotoResult) -> Photo {
        Photo(id: photo.id,
              size: CGSize(width: photo.width, height: photo.height),
              createdAt: dateFormatter.date(from: photo.createdAt ?? ""),
              welcomeDescription: photo.description ?? "",
              thumbImageURL: photo.urls.thumb,
              largeImageURL: photo.urls.regular,
              isLiked: photo.likedByUser)
    }
    
}

