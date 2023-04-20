//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 02.04.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenIdentifier = "ShowAuthenticationScreen"
    private let profileService = ProfileService.shared
    private let oauth2Service: NetworkRouting = OAuth2Service()
    private let imageService = ProfileImageService.shared
    private var storage = OAuth2TokenStorage()
    
    private var isFirstLoad = true
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "VectorLaunchScreen")
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        view.addSubview(imageView)
        setupConstraints()
       
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      // storage.removeToken()
        
        if isFirstLoad  {
            
            if let token = storage.token {
                
                fetchProfile(token)
                
            } else {
                showAuthViewController()
                //    switchToTabBarController()
                isFirstLoad = false
            }
        }
    }
    private func showAuthViewController() {
        
        let authViewController = UIStoryboard(
            name: "Main",
            bundle: .main
        ).instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController
        authViewController?.delegate = self
        authViewController?.modalPresentationStyle = .fullScreen
        
        present(authViewController ?? AuthViewController(), animated: true)
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 70),
            imageView.heightAnchor.constraint(equalToConstant: 70),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Неудалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
           // self.serviceError = false
            self.showAuthViewController()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.fetchAuthToken(code)
        }
    }
        private func fetchAuthToken(_ code: String) {
            oauth2Service.fetchAuthToken(code: code) { [weak self] result  in
                guard let self else { return }
                DispatchQueue.main.async {
                    switch result {
                        
                    case .success(let data):
                        print(data)
                        UIBlockingProgressHUD.dismiss()
                        self.switchToTabBarController()
                        self.storage.token = data.accessToken
                        self.fetchProfile(data.accessToken)
                    case .failure(_):
                        UIBlockingProgressHUD.dismiss()
                        self.showAlert()
                        break
                        
                    }
                }
            }
        }
    }

    extension SplashViewController {
        private func fetchProfile(_ token: String?) {
            guard let token else { return }
            profileService.fetchProfile(token) { result in
                switch result {
                    
                case .success(let profile):
                    UIBlockingProgressHUD.dismiss()
                    self.imageService.fetchProfileImageURL(userName: profile.userName) { _ in }
                    self.switchToTabBarController()
                case .failure(_):
                    self.showAlert()
                    break
                }
            }
        }
    }


