//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Andrey Ovchinnikov on 27.02.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    private let gradient = CAGradientLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        gradient.frame = containerView.bounds
    }
    
    func setGradient() {
        let startColor = CGColor(red: 26, green: 27, blue: 34, alpha: 0)
        let endColor = CGColor(red: 26, green: 27, blue: 34, alpha: 0.2)
        gradient.colors = [startColor, endColor]
        containerView.layer.insertSublayer(gradient, at: 0)
    }
}
