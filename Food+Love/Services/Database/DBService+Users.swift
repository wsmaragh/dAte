//  DBService+Users.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth

extension DBService {

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
	
	public func addUser() {
		let user = DBService.manager.getLovers().child((AuthUserService.getCurrentUser()?.uid)!)
		user.setValue(["name"     : AuthUserService.getCurrentUser()?.displayName,
									 "email"		: AuthUserService.getCurrentUser()?.email,
									 "profileImageUrl": AuthUserService.getCurrentUser()?.photoURL])
			{ (error, dbRef) in
				if let error = error { print("addUser error: \(error.localizedDescription)")}
				else { print("user successfully added to database reference: \(dbRef)")}
			}
	}

	public func addUser(name: String, email: String, profileImageUrl: String) {
		let user = DBService.manager.getLovers().child((AuthUserService.getCurrentUser()?.uid)!)
		user.setValue(["name"     : AuthUserService.getCurrentUser()?.displayName,
									 "email"		: AuthUserService.getCurrentUser()?.email,
									 "profileImageUrl": AuthUserService.getCurrentUser()?.photoURL])
		{ (error, dbRef) in
			if let error = error { print("addUser error: \(error.localizedDescription)")}
			else { print("user successfully added to database reference: \(dbRef)")}
		}
	}

	public func loadAllUsers(completionHandler: @escaping ([Lover]?) -> Void) {
			let usersRef = DBService.manager.getLovers()
			usersRef.observe(.value) { (snapshot) in
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

