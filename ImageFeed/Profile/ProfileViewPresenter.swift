//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 15.05.2023.
//

import UIKit

public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    var profileImageServiceObserver: NSObjectProtocol? { get set }
    func profileImageObserver()
    func showLogoutAlert(vc: UIViewController)
    
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    var profileImageServiceObserver: NSObjectProtocol?
    
    weak var view: ProfileViewControllerProtocol?
    
    func profileImageObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.view?.updateAvatar()
        }
        view?.updateAvatar()
    }
    
    func showLogoutAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Выход из аккаунта",
                                      message: "Вы уверены что хотите выйти",
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Да", style: .default) { _ in
            OAuth2TokenStorage().deleteToken()
            WebViewViewController.cleanCookie()
            guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration")}
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
        }
        let noAction = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(noAction)
        vc.present(alert, animated: true)
    }
}
