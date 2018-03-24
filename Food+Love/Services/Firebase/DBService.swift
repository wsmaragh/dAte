
//  DBService.swift
//  Food+Love
//  Created by Winston Maragh on 3/15/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import FirebaseDatabase
import FirebaseAuth


class DBService {

	//MARK: Properties
	private var dbRef: DatabaseReference!
	private var loversRef: DatabaseReference!
	private var imagesRef: DatabaseReference!


	private init(){
		// reference to the root of the Firebase database
		dbRef = Database.database().reference()

		// children of root database node
		loversRef = dbRef.child("lovers")
		imagesRef = dbRef.child("images")
	}
	static let manager = DBService()

    public func formatDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY h:mm a"
        return dateFormatter.string(from: date)
    }

	public func getDB()-> DatabaseReference { return dbRef }
	public func getLovers()-> DatabaseReference { return loversRef }
	public func getImages()-> DatabaseReference { return imagesRef }


	
	func getUserInfoFromDatabase() -> Lover {
		let uid = Auth.auth().currentUser?.uid
		var lover: Lover!
		Database.database().reference().child("lovers").child(uid!).observe(.value, with: { (snapshot) in
			if let userInfoDict = snapshot.value as? [String : AnyObject] {
				lover = Lover(dictionary: userInfoDict)
			}
		}, withCancel: nil)
		return lover
	}


	public func addLover(uid: String, name: String, email: String, profileImage: UIImage) {
//		let user = DBService.manager.getLovers().child((AuthUserService.getCurrentUser()?.uid)!)
		let user = DBService.manager.getLovers().child((Auth.auth().currentUser?.uid)!)
		user.setValue(["name"     : name,
									 "email"		: email])
		{ (error, dbRef) in
			if let error = error { print("addUser error: \(error.localizedDescription)")}
			else { print("user successfully added to database reference: \(dbRef)")}
		}
		StorageService.manager.storeUserImage(image: profileImage)
	}

	public func retrieveAllLovers(completionHandler: @escaping ([Lover]?) -> Void) {
		let loversRef = DBService.manager.getLovers()
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

	public func updateUserName(name: String) {
		guard let currentUser = AuthUserService.getCurrentUser() else {print("No user authenticated"); return}
		DBService.manager.getLovers().child(currentUser.uid).updateChildValues(["name": name])
	}

	public func updateEmail(email: String) {
		guard let currentUser = AuthUserService.getCurrentUser() else {print("No user authenticated"); return}
		DBService.manager.getLovers().child(currentUser.uid).updateChildValues(["email": email])
	}

	public func updateUserImage(profileImageUrl: String) {
		guard let currentUser = AuthUserService.getCurrentUser() else {print("No user authenticated"); return}
		DBService.manager.getLovers().child(currentUser.uid).updateChildValues(["profileImageUrl": profileImageUrl])
	}



}


