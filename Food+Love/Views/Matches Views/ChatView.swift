//
//  ChatProfileView.swift
//  Food+Love
//
//  Created by C4Q on 3/26/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit


class ChatProfileView: UIView {
	@IBOutlet weak var loverImageView: RoundedImageView!
	@IBOutlet weak var loverNameLabel: UILabel!
	@IBOutlet weak var loverInfoLabel: UILabel!
	@IBOutlet weak var loverFoodPreference: UILabel!
}


class ChatSendView: UIView {
	@IBOutlet weak var photoButton: UIButton!
	@IBOutlet weak var locationButton: UIButton!
	@IBOutlet weak var messageTF: UITextField!
	@IBOutlet weak var sendButton: UIButton!
}

