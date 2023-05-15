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
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let imageListViewController = storyboard.instantiateViewController(withIdentifier: "ImagesListViewController")
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil)
        profileViewPresenter.view = profileViewController
        profileViewController.presenter = profileViewPresenter
        
        self.viewControllers = [imageListViewController, profileViewController]
    }
}
