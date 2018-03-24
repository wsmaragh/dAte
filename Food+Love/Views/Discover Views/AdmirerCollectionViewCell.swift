//
//  AdmirerCollectionViewCell.swift
//  Food+Love
//
//  Created by Gloria Washington on 3/21/18.
//  Copyright © 2018 Gloria Washington. All rights reserved.
//

import UIKit

class AdmirerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var admirerImageView: UIImageView!
    @IBOutlet weak var admirerFoodsLabel: UILabel!
    @IBOutlet weak var admirerNameLabel: UILabel!
    @IBOutlet weak var admirerShareLabel: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        fixImageView()
//        admirerNameLabel.textColor = UIColor.black
//        layer.cornerRadius = 14
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowOpacity = 0.3
//        layer.shadowOffset = CGSize(width: 0, height: 5)
//        layer.masksToBounds = false
    }

    func fixImageView() {
        admirerImageView.layer.masksToBounds = true
        admirerImageView.clipsToBounds = true
    }
      override func layoutSubviews() {
        admirerNameLabel.textColor = UIColor.black
        layer.cornerRadius = 14
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.masksToBounds = false
    }
    
    
    
    func configureCell(cellImage: UIImage, name: String) {
        self.admirerImageView.image = cellImage
        self.admirerNameLabel.text = "\(name) liked you!"
    }
}
