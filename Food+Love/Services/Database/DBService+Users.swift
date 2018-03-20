//  DBService+Users.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit
import FirebaseDatabase
import CoreData

extension DBService {

	public func addUser() {
		let user = DBService.manager.getUsers().child((AuthUserService.getCurrentUser()?.uid)!)
		user.setValue(["name"     : AuthUserService.getCurrentUser()?.displayName,
									 "email"		: AuthUserService.getCurrentUser()?.email,
									 "profileImageUrl": AuthUserService.getCurrentUser()?.photoURL])
			{ (error, dbRef) in
				if let error = error { print("addUser error: \(error.localizedDescription)")}
				else { print("user successfully added to database reference: \(dbRef)")}
			}
	}

	public func addUser(name: String, email: String, profileImageUrl: String) {
		let user = DBService.manager.getUsers().child((AuthUserService.getCurrentUser()?.uid)!)
		user.setValue(["name"     : AuthUserService.getCurrentUser()?.displayName,
									 "email"		: AuthUserService.getCurrentUser()?.email,
									 "profileImageUrl": AuthUserService.getCurrentUser()?.photoURL])
		{ (error, dbRef) in
			if let error = error { print("addUser error: \(error.localizedDescription)")}
			else { print("user successfully added to database reference: \(dbRef)")}
		}
	}

	public func loadAllUsers(completionHandler: @escaping ([Lover]?) -> Void) {
			let usersRef = DBService.manager.getUsers()
			usersRef.observe(.value) { (snapshot) in
					var allLovers = [Lover]()
					for child in snapshot.children {
							let dataSnapshot = child as! DataSnapshot
							if let dict = dataSnapshot.value as? [String: String] {
								let lover = Lover.init(dictionary: dict)
								allLovers.append(lover)
							}
					}
					completionHandler(allLovers)
			}
	}

	public func updateUserName(userID: String, name: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["name": name])
	}

	public func updateEmail(userID: String, email: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["email": email])
	}

	public func updateUserImage(userID: String, profileImageUrl: String) {
		DBService.manager.getUsers().child(userID).updateChildValues(["profileImageUrl": profileImageUrl])
	}

}

