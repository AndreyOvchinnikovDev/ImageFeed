//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 12.04.2023.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping(Result<String, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let url = URL(string: "https://api.unsplash.com/users/\(userName)") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(OAuth2TokenStorage().token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            switch result {
                
            case .success(let data):
                self?.avatarURL = data.profileImage["small"]
                completion(.success(data.profileImage["small"] ?? "medium"))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": data.profileImage["small"] ?? "medium"])
                self?.task = nil
            case .failure(_):
                completion(.failure(NetworkError.urlSessionError))
            }
        }
        self.task = task
    }
}
