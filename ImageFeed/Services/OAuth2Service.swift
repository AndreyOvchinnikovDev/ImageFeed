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
}

protocol NetworkRouting {
    func fetchAuthToken(code: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class OAuth2Service: NetworkRouting {
    enum Urls: String {
        case urlToGetCode = "https://unsplash.com/oauth/authorize"
        case urlToGetToken = "https://unsplash.com/oauth/token"
    }
    
    func fetchAuthToken(code: String, completion: @escaping (Result<Data, Error>) -> Void) {
        var urlComponents = URLComponents(string: Urls.urlToGetToken.rawValue)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        let url = urlComponents.url!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
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
            DispatchQueue.main.async {
                completion(.success(data))
                
            }
        }
        task.resume()
    }
    
}
