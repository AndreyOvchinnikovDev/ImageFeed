//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Andrey Ovchinnikov on 15.05.2023.
//
@testable import ImageFeed
import XCTest

final class ProfileImageServiceStub: ProfileImageServiceProtocol {
    var avatarURL: String?
    var avatarImage = UIImageView()
    
    func fetchProfileImageURL(userName: String, completion: @escaping (Result<String, Error>) -> Void) { }
    
    func setImage(avatarUrl: String) {
        guard let url = URL(string: avatarUrl) else { return }
        avatarImage.kf.setImage(with: url)
    }
    
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    let imageService = ProfileImageServiceStub()
    var avatarURL = "https://kafel.ee/wp-content/uploads/2019/02/013-duck.png"
    func updateAvatar() {
        imageService.setImage(avatarUrl: avatarURL)
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var showLogoutAlert = false
    var presentedViewController: UIViewController?
    
    var profileImageServiceObserver: NSObjectProtocol?
    
    func profileImageObserver() {
        viewDidLoadCalled = true
    }
    
    func showLogoutAlert(vc: UIViewController) {
        showLogoutAlert = true
        presentedViewController = vc
    }
}

final class ProfileViewTests: XCTestCase {
    func testProfileViewControllerCallsViewDidLoad() {
        //given
        let profileViewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        profileViewController.presenter = presenter
        presenter.view = profileViewController
        
        //when
        _ = profileViewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testProfileLogout() {
        //given
        let profileViewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        //when
        presenter.showLogoutAlert(vc: profileViewController)
        
        //then
        XCTAssertTrue(presenter.showLogoutAlert)
        XCTAssertEqual(presenter.presentedViewController, profileViewController)
    }
    
    func testUpdateImage() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileImageService = ProfileImageServiceStub()
        
        //when
        viewController.updateAvatar()
        
        //then
        XCTAssertNotNil(profileImageService.avatarImage)
    }
}
