//  ConversationCell.swift
//  Food+Love
//  Created by C4Q on 3/21/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Firebase

class ConversationCell: UITableViewCell {
	@IBOutlet weak var loverImage: UIImageViewX!
	@IBOutlet weak var loverName: UILabel!
	@IBOutlet weak var lastMessage: UILabel!
	@IBOutlet weak var timeStamp: UILabel!

	func configureCell(conversation: Message){
		let id = conversation.chatPartnerId()
		let ref = Database.database().reference().child("lovers").child(id)
		ref.observeSingleEvent(of: .value, with: { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject] {
				self.loverName.text = dict["name"] as? String
				if let profileImageStr = dict["profileImageUrl"] as? String {
					self.loverImage.loadImageUsingCacheWithUrlString(profileImageStr)
				}
				self.lastMessage.text = conversation.text
				if let seconds = conversation.timeStamp?.doubleValue {
					let timesnapDate = Date.init(timeIntervalSince1970: seconds)
					let dateFormatter = DateFormatter()
//					dateFormatter.dateFormat = "hh:mm:ss a"
					dateFormatter.dateFormat = "E, MMM d, hh:mm a"
					self.timeStamp.text = dateFormatter.string(from: timesnapDate as Date)
				}
			}
		}, withCancel: nil)
	}


	
}
