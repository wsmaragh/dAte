//
//  NewAdmirerCollectionViewCell.swift
//  Food+Love
//
//  Created by C4Q on 3/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class NewAdmirerCollectionViewCell: UICollectionViewCell {

  
    @IBOutlet weak var userImageView: UIImageViewX!
    @IBOutlet weak var favoriteFoodImageView: UIImageViewX!
    @IBOutlet weak var nameLabel: UILabel!
   
    @IBOutlet weak var faveCuisinesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 10
      self.userImageView.layer.cornerRadius = userImageView.frame.width / 2
        self.favoriteFoodImageView.layer.cornerRadius = favoriteFoodImageView.frame.width / 2
        self.userImageView.layer.masksToBounds = true
        self.favoriteFoodImageView.layer.masksToBounds = true
        
    }
    

}
