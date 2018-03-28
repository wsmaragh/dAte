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
    @IBOutlet weak var userNameLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
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
