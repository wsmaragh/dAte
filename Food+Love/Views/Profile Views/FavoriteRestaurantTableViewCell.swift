//
//  FavoriteRestaurantTableViewCell.swift
//  Food+Love
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class FavoriteRestaurantTableViewCell: UITableViewCell {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var favoriteRestaurantTV: UITextView!
    @IBOutlet weak var mainBackground: UIView!

    override func layoutSubviews() {
        //adds shadow to cells
        mainBackground.layer.backgroundColor = UIColor.white.cgColor
        mainBackground.layer.cornerRadius = 8
        mainBackground.layer.masksToBounds = true
        shadowView.layer.backgroundColor = UIColor.white.cgColor //Needed to set cell color here so it does not take on table view background. Do for both layers!
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.23
        shadowView.layer.shadowRadius = 4
        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
        shadowView.layer.shouldRasterize = true

    }
    

}
