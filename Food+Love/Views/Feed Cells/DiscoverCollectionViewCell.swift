//
//  DiscoverCollectionViewCell.swift
//  Food+Love
//
//  Created by C4Q on 3/21/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var labelBackgroundColorView: UIView!
    @IBOutlet weak var userNameAgeLabel: UILabel!
    @IBOutlet weak var commonFoodLabel: UILabel!
    
    public func configCell(userImage: UIImage, name: String, age: Int) {
        self.userPictureImageView.image = userImage
        self.userNameAgeLabel.text = "\(name), \(age)"
        
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        userPictureImageView.layer.masksToBounds = true
        userPictureImageView.layer.cornerRadius = 10
        layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5

    }
    
}
