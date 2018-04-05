
//  ConversationCell.swift
//  Food+Love
//  Created by Winston Maragh on 3/21/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Firebase


class ConversationCell: UITableViewCell {
	@IBOutlet weak var loverImage: UIImageViewX!
	@IBOutlet weak var loverName: UILabel!
	@IBOutlet weak var lastMessage: UILabel!
	@IBOutlet weak var timeStamp: UILabel!
	@IBOutlet weak var respondLabel: UILabel!
	@IBOutlet weak var onlineButton: UIButton!
	
	func configureCell(conversation: Message){
		let id = conversation.partnerId()
		let ref = Database.database().reference().child("lovers").child(id)
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject] {
				self.loverName.text = dict["name"] as? String
				if let profileImageStr = dict["profileImageUrl"] as? String {
					self.loverImage.loadImageUsingCacheWithUrlString(profileImageStr)
				}
				self.lastMessage.text = conversation.text
				if conversation.fromId == Auth.auth().currentUser?.uid {
					self.respondLabel.isHidden = true
				} else {
					self.respondLabel.isHidden = false
				}

				if let seconds = conversation.timeStamp?.doubleValue {
					let timesnapDate = Date.init(timeIntervalSince1970: seconds)
					let dateFormatter = DateFormatter()
					dateFormatter.dateFormat = "E, MMM d, hh:mm a"
					self.timeStamp.text = dateFormatter.string(from: timesnapDate as Date)
				}
			}
		}, withCancel: nil)
	}


	
}
