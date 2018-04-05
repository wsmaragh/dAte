
//  DBService.swift
//  Food+Love
//  Created by Winston Maragh on 3/15/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import FirebaseDatabase
import FirebaseAuth


class DBService {

	static let manager = DBService()

	private init(){
		dbRef = Database.database().reference()
		loversRef = dbRef.child("lovers")
		conversationsRef = dbRef.child("conversations")
		messagesRef = dbRef.child("messages")
		categoriesRef = dbRef.child("categories")
	}

	// MARK: Properties
	private var dbRef: DatabaseReference!
	private var loversRef: DatabaseReference!
	private var conversationsRef: DatabaseReference!
	private var messagesRef: DatabaseReference!
	private var categoriesRef: DatabaseReference!

	// MARK: Helper Methods
	public func getDBRef()-> DatabaseReference { return dbRef }
	public func getLoversRef()-> DatabaseReference { return loversRef }
	public func getConversationsRef()-> DatabaseReference { return conversationsRef }
	public func getMessagesRef()-> DatabaseReference { return messagesRef }
	public func getCategoriesRef()-> DatabaseReference {return categoriesRef}


	// Format date
	public func formatDateforMessages(with date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, YYYY h:mm a"
		return dateFormatter.string(from: date)
	}

	public func formatDateforDOB(with date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, YYYY"
		return dateFormatter.string(from: date)
	}

/*

	// Get
    func getCurrentLover(completionHandler: @escaping (Lover?, Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No current user exist")
           completionHandler(nil, AppError.noUserExist)
            return
        }
        Database.database().reference().child("lovers").child(uid).observe(.value) { (snapshot) in
            var lover: Lover?
            
         //   let snap = snapshot.value as! DataSnapshot
            if let infoDict = snapshot.value as? [String: AnyObject] {
                lover = Lover(dictionary: infoDict)
                completionHandler(lover, nil)
            
            }
        }

        }
		


//	func getLover(uid: String) -> Lover {
//		var lover: Lover?
//		Database.database().reference().child("lovers").child(uid).observe(.value, with: { (snapshot) in
//			if let loverInfoDict = snapshot.value as? [String : AnyObject] {
//				lover = Lover(dictionary: loverInfoDict)
////				print(lover.name)
////				return lover
//			}
//		}, withCancel: nil)
//		if let lover = lover {
//			return lover
//		}
//	}

    func getMultipleLovers(uids: [String], completionHandler: @escaping ([Lover]) -> Void) {
		var lovers = [Lover]()
		for uid in uids {
			Database.database().reference().child("lovers").child(uid).observe(.value, with: { (snapshot) in
				if let loverInfoDict = snapshot.value as? [String : AnyObject] {
					let lover = Lover(dictionary: loverInfoDict)
					lovers.append(lover)
				}
			}, withCancel: nil)
		}
        completionHandler(lovers)
	}

	func getAllLovers() -> [Lover] {
		let loversRef = DBService.manager.getLoversRef()
		var lovers = [Lover]()
		loversRef.observe(.value) { (snapshot) in
			for child in snapshot.children {
				let dataSnapshot = child as! DataSnapshot
				if let dict = dataSnapshot.value as? [String: AnyObject] {
					let lover = Lover.init(dictionary: dict)
					lovers.append(lover)
				}
			}
		}
		return lovers
	}

	func retrieveLover(loverId: String, completionHandler: @escaping (Lover?) -> Void) {
		let loversRef = DBService.manager.getLoversRef().child(loverId)
		loversRef.observe(.value) { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject] {
				let lover = Lover(dictionary: dict)
				completionHandler(lover)
			}
		}
	}


//	func getLover(uid: String) -> Lover {
//		var lover: Lover!
//		Database.database().reference().child("lovers").child(uid).observe(.value, with: { (snapshot) in
//			if let loverInfoDict = snapshot.value as? [String : AnyObject] {
//				lover = Lover(dictionary: loverInfoDict)
//			}
//		}, withCancel: nil)
//		return lover
//	}

	func retrieveAllLovers(completionHandler: @escaping ([Lover]?) -> Void) {
		let loversRef = DBService.manager.getLoversRef()
		loversRef.observe(.value) { (snapshot) in
				var allLovers = [Lover]()
				for child in snapshot.children {
						let dataSnapshot = child as! DataSnapshot
						if let dict = dataSnapshot.value as? [String: AnyObject] {
							let lover = Lover.init(dictionary: dict)
							allLovers.append(lover)
						}
				}
				completionHandler(allLovers)
		}
	}

//    func getAllLoversExceptCurrent() -> [Lover]{
//        var lovers = [Lover]()
//        Database.database().reference().child("lovers").observe(.childAdded, with: { (snapshot) in
//            if let dict = snapshot.value as? [String: AnyObject]{
//                let lover = Lover(dictionary: dict)
//                lover.id = snapshot.key
//                if lover.id != Auth.auth().currentUser?.uid {
//                    lovers.append(lover)
//                }
//            }
//        }, withCancel: nil)
//        return lovers
//    }

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

     */
    
}

