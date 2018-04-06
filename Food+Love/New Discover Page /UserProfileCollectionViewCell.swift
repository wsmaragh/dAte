//
//  UserProfileCollectionViewCell.swift
//  RecreateDemoCells
//
//  Created by C4Q on 4/4/18.
//  Copyright © 2018 Glo. All rights reserved.
//

import UIKit
import expanding_collection


class UserProfileCollectionViewCell: BasePageCollectionCell {

    @IBOutlet weak var customTitle: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageViewX!
//    @IBOutlet weak var faveFoodImageView: UIImageView!
//    @IBOutlet weak var foodTitleView: UIView!
    @IBOutlet weak var favoriteFoodNameLabel: UILabel!
    //    
    @IBOutlet weak var favoriteCuisinesLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var favFoodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        customTitle.layer.shadowRadius = 2
//        customTitle.layer.shadowOffset = CGSize(width: 0, height: 3)
//        customTitle.layer.shadowOpacity = 0.5
//        customTitle.layer.shadowColor = UIColor.black.cgColor
    }

}
