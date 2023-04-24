//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 02.04.2023.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decodingError
    case invalidURL
}

protocol NetworkRouting {
    func fetchAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void)
}

class OAuth2Service: NetworkRouting {
    enum Urls: String {
        case urlToGetCode = "https://unsplash.com/oauth/authorize"
        case urlToGetToken = "https://unsplash.com/oauth/token"
    }
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(code: String, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard var urlComponents = URLComponents(string: Urls.urlToGetToken.rawValue) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                
                completion(.success(data))
                self.task = nil
            case .failure(_):
                self.lastCode = nil
                completion(.failure(NetworkError.urlSessionError))
            }
        }
        self.task = task
    }
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.urlSessionError))
                    return
                }
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.httpStatusCode(response.statusCode)))
                    return
                }
            }
            guard let data = data else { return }
            
            do {
                let responseBody = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(responseBody))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.decodingError))
                }
            }
        }
        task.resume()
        return task
    }
}
