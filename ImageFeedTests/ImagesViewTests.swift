//
//  ImagesViewTests.swift
//  ImageFeedTests
//
//  Created by Andrey Ovchinnikov on 16.05.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {}
}

final class ImagesViewPresenterTestsSpy: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled = false
    var updateTableViewCalled = false
    var showAlertCalled = false
    var photos: [Photo] = []
    var presentedViewController = UIViewController()
    var needsNewPhoto: Bool = false
    
    func photosObserver() {
        viewDidLoadCalled = true
    }
    
    func showAlert(vc: UIViewController) {
        showAlertCalled = true
        presentedViewController = vc
    }
    
    func updateTableView() {
        updateTableViewCalled = true
    }
    
    func needsNewPhoto(indexPath: IndexPath) {
        if indexPath.row + 1 == photos.count {
            needsNewPhoto = true
        }
    }
}

final class ImagesViewTests: XCTestCase {
    let indexPath = IndexPath(row: 9, section: 0)
    let photo = Photo(id: "",
                      size: CGSize(width: 1, height: 1),
                      createdAt: nil,
                      welcomeDescription: "",
                      thumbImageURL: "",
                      largeImageURL: "",
                      isLiked: true)

    
    func testImagesListViewControllerCallsViewDidLoad() {
        //given
        let imagesViewController = ImagesListViewController()
        let presenter = ImagesViewPresenterTestsSpy()
        presenter.view = imagesViewController
        imagesViewController.presenter = presenter
        
        //when
        _ = imagesViewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPhotoObserverCalled() {
        //given
        let presenter = ImagesViewPresenterTestsSpy()
        
        //when
        presenter.photosObserver()
        
        //then
        XCTAssertNotNil(presenter.photos)
    }
    
    func testUpdateTableView() {
        //given
        let presenter = ImagesViewPresenterTestsSpy()

        //when
        presenter.updateTableView()
        
        //then
        XCTAssertTrue(presenter.updateTableViewCalled)
    }
    
    func testShowAlert() {
        //given
        let imagesListViewController = ImagesListViewController()
        let presenter = ImagesViewPresenterTestsSpy()
        
        //when
        presenter.showAlert(vc: imagesListViewController)
        
        //then
        XCTAssertTrue(presenter.showAlertCalled)
        XCTAssertEqual(presenter.presentedViewController, imagesListViewController)
    }
    
    func testNeedNewPhoto() {
        //given
        let presenter = ImagesViewPresenterTestsSpy()
        presenter.photos = Array(repeating: photo, count: 10)
        let controller = ImagesListViewControllerSpy()
        controller.presenter = presenter
        
        //when
        presenter.needsNewPhoto(indexPath: indexPath)
        
        //then
        XCTAssertTrue(presenter.needsNewPhoto)
    }
}
