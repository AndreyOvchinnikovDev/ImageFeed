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
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    func fetchPhotosNextPage(completion: @escaping(Result<[Photo], Error>) -> Void) {
        task?.cancel()
        let nextPage = lastLoadedPage
        lastLoadedPage += 1
        print(nextPage, lastLoadedPage)
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
        let task = URLSession.shared.objectTask(for: request) { (result: Result<[PhotoResult], Error>) in
           
            switch result {
                
            case .success(let data):
                
                let photos = data.map { photo in
                    Photo.createPhoto(photo: photo)
                }
                self.photos.append(contentsOf: photos)
                print(self.photos.count)
                
                completion(.success(photos))
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        self.task = task
        task.resume()
    }
}