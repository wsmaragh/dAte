//
//  AdmirerCollectionViewCell.swift
//  Food+Love
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class AdmirerCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func layoutSubviews() {
        backView.layer.cornerRadius = 10
        backView.layer.masksToBounds = true
        backView.layer.shadowRadius = 4.0
        backView.layer.shadowColor = UIColor.lightGray.cgColor
        backView.layer.shadowOpacity = 2
        backView.layer.shadowOffset = CGSize(width: 0, height: 3)
        backView.layer.borderColor = UIColor.black.cgColor
        backView.layer.borderWidth = 0.5
    }

}
