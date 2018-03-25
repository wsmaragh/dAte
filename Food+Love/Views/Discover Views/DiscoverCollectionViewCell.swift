//
//  DiscoverCollectionViewCell.swift
//  Food+Love
//
//  Created by Gloria Washington on 3/21/18.
//  Copyright © 2018 Gloria Washington. All rights reserved.
//

import UIKit

class DiscoverCollectionViewCell: UICollectionViewCell {
    

    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var labelBackgroundColorView: UIView!
    @IBOutlet weak var userNameAgeLabel: UILabel!
    @IBOutlet weak var userPictureImageView: UIImageView!
    
    public func configCell(lover: Lover) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//        let date = dateFormatter.date(from:lover.dateOfBirth!)!
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
//        let finalDate = calendar.date(from:components)
//        let now = Date()
//        let birthday = finalDate
//        let ageComponents = calendar.dateComponents([.year], from: birthday!, to: now)
//        let age = ageComponents.year
     }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userPictureImageView.layer.masksToBounds = true
        userPictureImageView.layer.cornerRadius = 10
        layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 2
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
    }
    
}
