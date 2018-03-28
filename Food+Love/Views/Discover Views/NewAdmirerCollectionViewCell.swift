//
//  NewAdmirerCollectionViewCell.swift
//  Food+Love
//
//  Created by C4Q on 3/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class NewAdmirerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageViewX!
    @IBOutlet weak var favoriteFoodImageView: UIImageViewX!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var faveFoodLabel: UILabel!
    @IBOutlet weak var faveCuisinesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func prepareForReuse() {
        super.prepareForReuse()
        userImageView.image = #imageLiteral(resourceName: "user2")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 10
    }

}
