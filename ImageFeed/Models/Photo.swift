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
    let createdAt: String
    let welcomeDescription: String
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    static func createPhoto(photo: PhotoResult) -> Photo {
        Photo(id: photo.id,
              size: CGSize(width: photo.width, height: photo.height),
              createdAt: dateFormat(date: photo.createdAt ?? "1 января 2000 г."),
              welcomeDescription: photo.description ?? "",
              thumbImageURL: photo.urls.thumb,
              largeImageURL: photo.urls.regular,
              isLiked: photo.likedByUser)
    }
   private static func dateFormat(date: String) -> String {
        let dateIso8601 = ISO8601DateFormatter()
        let dateDate = dateIso8601.date(from: date) ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateStyle = .long
        let stringDate = dateFormatter.string(from: dateDate)
        return stringDate
    }
    
}

