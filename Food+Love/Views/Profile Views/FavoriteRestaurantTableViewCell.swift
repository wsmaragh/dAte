//
//  FavoriteRestaurantTableViewCell.swift
//  Food+Love
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class FavoriteRestaurantTableViewCell: UITableViewCell {
 
    @IBOutlet weak var favoriteRestaurantTV: UITextView!
   @IBOutlet weak var mainBackground: UIView!

    override func layoutSubviews() {
        super.layoutSubviews()
        //adds shadow to cells
//        self.layer.backgroundColor = UIColor.yellow.cgColor
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.backgroundColor = UIColor.white.cgColor //Needed to set cell color here so it does not take on table view background. Do for both layers!
            self.layer.masksToBounds = false
        self.layer.shadowOffset = CGSize(width: 100, height: 100)
        self.layer.shadowColor = UIColor.red.cgColor
        self.layer.shadowOpacity = 0.23
        self.layer.shadowRadius = 4
//        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
//        shadowView.layer.shouldRasterize = true

    }
    

}
