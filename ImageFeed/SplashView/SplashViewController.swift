//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 02.04.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenIdentifier = "ShowAuthenticationScreen"
    
    private let service: NetworkRouting = OAuth2Service()
    private var storage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if storage.token == ""  {
            performSegue(withIdentifier: ShowAuthenticationScreenIdentifier, sender: nil)
        } else {
            switchToTabBarController()
        }
    }
}

private func switchToTabBarController() {
    guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
    let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
    window.rootViewController = tabBarController
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let token =  try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    self.storage.token = token.accessToken
                    switchToTabBarController()
                } catch {
                    print("error decode")
                    break
                }
            case .failure:
                break
            }
        }
    }
}
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowAuthenticationScreenIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(ShowAuthenticationScreenIdentifier)")}
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
