//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 25.04.2023.
//

import Foundation

class ImageListService {
    private(set) var photos: [Photo] = []
    private var lastLoadedPage = 1
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    func fetchPhotosNextPage(completion: @escaping(Result<[Photo], Error>) -> Void) {
        task?.cancel()
        
        let nextPage = lastLoadedPage
        lastLoadedPage += 1
        
        var urlComponents = URLComponents(string: "https://api.unsplash.com")
        urlComponents?.path = "/photos"
        urlComponents?.queryItems = [
            URLQueryItem(name: "page", value: String(nextPage)),
            URLQueryItem(name: "per_page", value: String(10)),
            URLQueryItem(name: "client_id", value: Constants.accessKey)
        ]
        guard let url = urlComponents?.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
                
            case .success(let data):
                let photos = data.map { photo in Photo.createPhoto(photo: photo) }
                
                DispatchQueue.main.async {
                    self.photos += photos
                }
                NotificationCenter.default.post(name: ImageListService.didChangeNotification, object: self)
                completion(.success(photos))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                print(error.localizedDescription)
                self.task = nil
            }
            
        }
        self.task = task
        task.resume()
    }
    
    func changeLike(photosId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        likeTask?.cancel()
        
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
        
        let task = URLSession.shared.objectTask(for: request) { (result: Result<LikePhotoResult, Error>) in
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


