//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 27.02.2023.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate : AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    weak var delegate: ImagesListCellDelegate?
    private let gradient = CAGradientLayer()
    
    override func prepareForReuse() {
       super.prepareForReuse()
        self.accessoryType = .none
        cellImage.kf.cancelDownloadTask()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        gradient.frame = containerView.bounds
    }
    
    @IBAction func likeButtonClocked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setGradient() {
        let startColor = CGColor(red: 26, green: 27, blue: 34, alpha: 0)
        let endColor = CGColor(red: 26, green: 27, blue: 34, alpha: 0.2)
        gradient.colors = [startColor, endColor]
        containerView.layer.insertSublayer(gradient, at: 0)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            likeButton.setImage(UIImage(named: "likeButtonOn"), for: .normal)
        } else {
            likeButton.setImage(UIImage(named: "likeButtonOff"), for: .normal)
        }
    }
}

