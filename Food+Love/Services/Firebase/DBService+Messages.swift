//
//  DBService+Messages.swift
//  Food+Love
//
//  Created by C4Q on 3/31/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

// MARK: Messages
extension DBService {




	//	func getNewMessages() {
	//		guard let uid = Auth.auth().currentUser?.uid else { return }
	//		let userMessageRef = DBService.manager.getUserMessages().child(uid)
	//
	//		// Observe for New Messages
	//		userMessageRef.observe(.childAdded, with: { (snapshot) in
	//			let userId = snapshot.key
	//			userMessageRef.child(userId).observe(.childAdded, with: { (mSnapshot) in
	//				let messageId = mSnapshot.key
	//				let messagesReference = DBService.manager.getMessages().child(messageId)
	//				messagesReference.observeSingleEvent(of:.value, with: { (snapshot) in
	//					if let dict = snapshot.value as? [String: AnyObject] {
	//						let message = Message(dictionary: dict)
	//						let chatPartnerID = message.chatPartnerId()
	//						self.conversationsDict[chatPartnerID] = message
	//						self.conversations = Array(self.conversationsDict.values)
	//						self.conversations =  self.conversations.sorted(by: { (message1, message2) -> Bool in
	//							return Date.init(timeIntervalSince1970: Double(message1.timeStamp!)) > Date.init(timeIntervalSince1970: Double(message2.timeStamp!))
	//						})
	//						self.reloadTable()
	//					}
	//				}, withCancel: nil)
	//			}, withCancel: nil)
	//		}, withCancel: nil)
	//
	//		// Observe for Delete Messages
	//		ref.observe(.childRemoved, with: { (snapshot) in
	//			self.conversationsDict.removeValue(forKey: snapshot.key)
	//		}, withCancel: nil)
	//	}


	//	// Get Message with message ID
	//	fileprivate func getMessageWithID(_ messageId: String) {
	//		let messagesReference = DBService.manager.getMessages().child(messageId)
	//		messagesReference.observeSingleEvent(of: .value, with: { (snapshot) in
	//			if let dictionary = snapshot.value as? [String: AnyObject] {
	//				let message = Message(dictionary: dictionary)
	//				let chatPartnerId = message.chatPartnerId()
	//				self.conversationsDict[chatPartnerId] = message
	//				self.attemptReloadOfTable()
	//			}
	//		}, withCancel: nil)
	//	}
	
}
