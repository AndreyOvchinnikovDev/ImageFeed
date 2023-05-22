//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 12.04.2023.
//

import Foundation

protocol ProfileImageServiceProtocol: AnyObject {
    var avatarURL: String? { get set }
    func fetchProfileImageURL(userName: String,  completion: @escaping(Result<String, Error>) -> Void)
}

final class ProfileImageService: ProfileImageServiceProtocol {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    var avatarURL: String?
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(userName: String,  completion: @escaping(Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let url = URL(string: "https://api.unsplash.com/users/\(userName)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        guard let token = OAuth2TokenStorage().token else {
            return assertionFailure("no token")
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self else { return }
            switch result {
                
            case .success(let data):
                let image = data.profileImage.small
                self.avatarURL = image
                completion(.success(self.avatarURL!))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": image])
                self.task = nil
            case .failure(_):
                completion(.failure(NetworkError.urlSessionError))
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
}
