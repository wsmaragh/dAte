
//  Message.swift
//  Food+Love
//  Created by Winston Maragh on 3/16/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import FirebaseAuth


class Message: NSObject {
	var fromId: String
	var toId: String
	var text: String?
	var imageUrl: String?
	var imageWidth: NSNumber?
	var imageHeight: NSNumber?
	var videoUrl: String?
	var timeStamp: NSNumber?
	var location: String?

	func partnerId() -> String {
		return (fromId == Auth.auth().currentUser?.uid ? toId : fromId)
	}

	init(dictionary: [String: AnyObject]) {
		self.fromId = dictionary["fromId"] as! String
		self.toId = dictionary["toId"] as! String
		self.text = dictionary["text"] as? String
		self.imageUrl = dictionary["imageUrl"] as? String
		self.imageWidth = dictionary["imageWidth"] as? NSNumber
		self.imageHeight = dictionary["imageHeight"] as? NSNumber
		self.videoUrl = dictionary["videoUrl"] as? String
		self.timeStamp = dictionary["timeStamp"] as? NSNumber
		self.location = dictionary["location"] as? String
	}

	init(fromId: String, toId: String, text: String?, imageUrl: String?, imageWidth: NSNumber?, imageHeight: NSNumber?, videoUrl: String?, timeStamp: NSNumber?, location: String?){
		self.fromId = fromId
		self.toId = toId
		self.text = text
		self.imageUrl = imageUrl
		self.imageWidth = imageWidth
		self.imageHeight = imageHeight
		self.videoUrl = videoUrl
		self.timeStamp = timeStamp
		self.location = location
	}

}

