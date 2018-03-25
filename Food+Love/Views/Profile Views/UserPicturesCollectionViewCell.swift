//
//  UserPicturesCollectionViewCell.swift
//  Food+Love
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class UserPicturesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userPictureImageView: UIImageView!

    public func configureCell(image: UIImage) {
        self.userPictureImageView.image = image
    }
}
