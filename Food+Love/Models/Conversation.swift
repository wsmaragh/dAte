
//  Conversation.swift
//  Food+Love
//  Created by Winston Maragh on 3/21/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Firebase


class Conversation: NSObject {

	var fromId: String?
	var text: String?
	var timeStamp: NSNumber?
	var toId: String?
	var imageUrl: String?
	var imageWidth: NSNumber?
	var imageHeight: NSNumber?
	var videoUrl: String?

	func partnerId() -> String {
		return (fromId == Auth.auth().currentUser?.uid ? toId : fromId)!
	}

	init(dictionary: [String: AnyObject]) {
		self.fromId = dictionary["fromId"] as? String
		self.text = dictionary["text"] as? String
		self.timeStamp = dictionary["timeStamp"] as? NSNumber
		self.toId = dictionary["toId"] as? String
		self.imageUrl = dictionary["imageUrl"] as? String
		self.imageWidth = dictionary["imageWidth"] as? NSNumber
		self.imageHeight = dictionary["imageHeight"] as? NSNumber
		self.videoUrl = dictionary["videoUrl"] as? String
	}

}

