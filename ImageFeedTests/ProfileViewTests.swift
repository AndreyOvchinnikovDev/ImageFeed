//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Andrey Ovchinnikov on 15.05.2023.
//
@testable import ImageFeed
import XCTest

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
    
}
