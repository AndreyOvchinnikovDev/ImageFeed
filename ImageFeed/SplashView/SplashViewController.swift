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
    
    private var serviceError: Bool = false
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if serviceError == true {
            showAlert()
        }
        if storage.token == "" {
            
            showAuthViewController()
            
        } else {
            profileService.fetchProfile(storage.token) {_ in
                self.imageService.fetchProfileImageURL  (userName: self.profileService.profile?.userName ?? "") { _ in }
                self.switchToTabBarController()
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
            self.serviceError = false
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
        
        oauth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.storage.token = data.accessToken
                switchToTabBarController()
                profileService.fetchProfile(storage.token) { _ in
                    ProfileImageService.shared.fetchProfileImageURL(userName:  self.profileService.profile?.userName ?? "") { _ in }
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.serviceError = true
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
}

