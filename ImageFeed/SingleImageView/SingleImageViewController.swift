//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 12.03.2023.
//

import UIKit

final class SingleImageViewController: UIViewController {

    var imageURL: URL?
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let imageURL {
            showImage(largeImageUrl: imageURL)
        }
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25

    }
    
    @IBAction private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton(_ sender: Any) {
        let share = UIActivityViewController(
            activityItems: [imageView.image as Any],
            applicationActivities: nil
        )
        share.overrideUserInterfaceStyle = .dark
        present(share,animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func showImage(largeImageUrl: URL) {
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: largeImageUrl) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else { return }
            switch result {
            case .success(let imageResult):
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure(_):
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Что-то пошло не так",
                                      message: "Попробовать еще раз?",
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "Повторить",
                                   style: .default) { [weak self] _ in
            guard let self, let imageURL else { return }
            self.showImage(largeImageUrl: imageURL)
            alert.dismiss(animated: true)
        }
        let noAction = UIAlertAction(title: "Не надо",
                                     style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        alert.addAction(noAction)
        present(alert, animated: true)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


