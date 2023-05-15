//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 11.04.2023.
//

import Foundation


final class ProfileService {
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    static let shared = ProfileService()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        task?.cancel()
        
        guard let url = Constants.defaultBaseURL else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                let profile = Profile.createProfile(profile: data)
                self.profile = profile
                completion(.success(profile))
                self.task = nil
            case .failure(_):
                completion(.failure(NetworkError.urlSessionError))
                self.task = nil
            }
        }
        self.task = task
    }
}

