
//  MatchesCell.swift
//  Food+Love
//  Created by Winston Maragh on 3/20/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit


class MatchesCell: UICollectionViewCell {
	@IBOutlet weak var matchImageView: UIImageView!
	@IBOutlet weak var matchNameLabel: UILabel!

	func configureCell(match: Lover){
		matchNameLabel.text = match.name
		if let profileImageStr = match.profileImageUrl {
			matchImageView.loadImageUsingCacheWithUrlString(profileImageStr)
		}
	}

}
