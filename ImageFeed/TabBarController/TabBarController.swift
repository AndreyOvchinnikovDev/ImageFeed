//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 17.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()
        let profileViewPresenter = ProfileViewPresenter()
        let imagesListPresenter = ImagesListPresenter()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController") as? ImagesListViewController else { return }
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        
        imageListViewController.configure(imagesListPresenter)
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
