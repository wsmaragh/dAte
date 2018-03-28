//
//  FaveFoodCollectionViewCell.swift
//  Food+Love
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class FaveFoodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var faveFoodLab: UILabel!
    

    override func layoutSubviews() {
        super.layoutSubviews()
//       faveFoodLab.textColor = UIColor.black
        self.layer.cornerRadius = 14
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }

    public func configureCell(food: String) {
        self.faveFoodLab.text = food
    }
}
