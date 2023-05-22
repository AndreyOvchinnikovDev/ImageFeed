//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 15.05.2023.
//

import UIKit

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    func photosObserver()
    func showAlert(vc: UIViewController)
    func updateTableView()
}

final class ImagesListPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListService = ImageListService.shared
    
    private var imageListServiceObserver: NSObjectProtocol?
    
    func photosObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImageListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self else { return }
                    self.updateTableView()
            }
    }
    
    func updateTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func showAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Что-то пошло не так",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Ок", style: .default)
        
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}
