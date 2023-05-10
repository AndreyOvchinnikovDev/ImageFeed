//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 25.04.2023.
//

import Foundation

class ImageListService {
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    static let shared = ImageListService()
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        
        if lastLoadedPage == nil {
            lastLoadedPage = 1
        } else {
            lastLoadedPage! += 1
        }
        
        guard let lastLoadedPage = lastLoadedPage else { return }
        
        var urlComponents = URLComponents(string: "https://api.unsplash.com")
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: String(lastLoadedPage)),
            URLQueryItem(name: "per_page", value: String(10)),
            URLQueryItem(name: "client_id", value: Constants.accessKey)
        ]
        guard let url = urlComponents?.url else { return }
        
        guard let token = OAuth2TokenStorage().token else { return }
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                let photos = data.map { photo in Photo.createPhoto(photo: photo) }
                self.photos += photos
                NotificationCenter.default.post(
                    name: ImageListService.didChangeNotification,
                    object: self)
                self.task = nil
            case .failure(let error):
                print(error.localizedDescription)
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photosId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if likeTask != nil { return }
        
        var urlComponents = URLComponents(string: "https://api.unsplash.com")
        urlComponents?.path = "/photos/\(photosId)/like"
        
        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        guard let token = OAuth2TokenStorage().token else { return }
        var request = URLRequest(url: url)
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = isLike ? "POST" : "DELETE"
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikePhotoResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    if let index = self.photos.firstIndex(where: { $0.id == photosId }) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(id: photo.id,
                                             size: photo.size,
                                             createdAt: photo.createdAt,
                                             welcomeDescription: photo.welcomeDescription,
                                             thumbImageURL: photo.thumbImageURL,
                                             largeImageURL: photo.largeImageURL,
                                             isLiked: !photo.isLiked)
                        self.photos[index] = newPhoto
                    }
                    completion(.success(()))
                    self.likeTask = nil
                }
            case .failure(let error):
                completion(.failure(error))
                self.likeTask = nil
            }
        }
        self.likeTask = task
        task.resume()
    }
    
}


