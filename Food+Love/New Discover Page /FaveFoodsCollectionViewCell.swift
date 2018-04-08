//
//  FaveFoodsCollectionViewCell.swift
//  RecreateDemoCells
//
//  Created by C4Q on 4/4/18.
//  Copyright © 2018 Glo. All rights reserved.
//

import UIKit

class FaveFoodsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var favoriteCuisinesLabel: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //       faveFoodLab.textColor = UIColor.black
        self.layer.cornerRadius = 14
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
    }
    
    public func configureCell(food: String) {
        self.favoriteCuisinesLabel.text = food
    }
}
