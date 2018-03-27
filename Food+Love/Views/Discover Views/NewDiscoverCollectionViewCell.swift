//
//  NewDiscoverCollectionViewCell.swift
//  Food+Love
//
//  Created by C4Q on 3/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class NewDiscoverCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var favoriteCuisinesLabel: UILabel!
    @IBOutlet weak var favoriteFoodImageView: UIImageViewX!
    @IBOutlet weak var favoriteFoodLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func layoutSubviews() {
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
    }

}
