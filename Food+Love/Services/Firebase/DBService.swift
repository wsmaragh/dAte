
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
    // added
    private var usersRef: DatabaseReference!
    private var userProfileRef: DatabaseReference!
    private var userLikeRef: DatabaseReference!

	private init(){
		// reference to the root of the Firebase database
		dbRef = Database.database().reference()

		// children of root database node
		loversRef = dbRef.child("lovers")
		imagesRef = dbRef.child("images")
        // added
        userProfileRef = dbRef.child("userProfile")
        userLikeRef = dbRef.child("userLikes")
	}
	static let manager = DBService()

    public func formatDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY h:mm a"
        return dateFormatter.string(from: date)
    }

	public func getDBRef()-> DatabaseReference { return dbRef }
	public func getLoversRef()-> DatabaseReference { return loversRef }

// added
    public func getImagesRef()-> DatabaseReference { return imagesRef }
    public func getUserProfileRef()-> DatabaseReference { return userProfileRef }
    public func getUserLikeRef()-> DatabaseReference { return userLikeRef }

	public func getImages()-> DatabaseReference { return imagesRef }

	// Add
	public func addLover(name: String, email: String, profileImage: UIImage) {
		let user = DBService.manager.getLoversRef().child((Auth.auth().currentUser?.uid)!)
		user.setValue(["name"     : name,
									 "email"		: email])
		{ (error, dbRef) in
			if let error = error { print("addUser error: \(error.localizedDescription)")}
			else { print("user successfully added to database reference: \(dbRef)")}
		}
	
	}

	public func addLoverDetails(dateOfBirth: String?,
															zipcode: String?,
															city: String?,
															bio: String?,
															gender: String?,
															genderPreference: String?,
															smoke: String?,
															drink: String?,
															drugs: String?) {
		let user = DBService.manager.getLoversRef().child((Auth.auth().currentUser?.uid)!)
		user.setValue(["dateOfBirth": dateOfBirth,
									 "zipcode": zipcode,
									 "city": city,
									 "bio": bio,
									 "gender" : gender,
									 "genderPreference"	: genderPreference,
									 "smoke" : smoke,
									 "drink": drink,
									 "drugs" : drugs])
		{ (error, dbRef) in
			if let error = error { print("addUser error: \(error.localizedDescription)")}
			else { print("user successfully added to database reference: \(dbRef)")}
		}
	}



	// Get
	func getCurrentLover() -> Lover {
		let uid = Auth.auth().currentUser?.uid
		var lover: Lover!
		Database.database().reference().child("lovers").child(uid!).observe(.value, with: { (snapshot) in
			if let userInfoDict = snapshot.value as? [String : AnyObject] {
				lover = Lover(dictionary: userInfoDict)
			}
		}, withCancel: nil)
		return lover
	}

	func getLover(uid: String) -> Lover {
		var lover: Lover!
		Database.database().reference().child("lovers").child(uid).observe(.value, with: { (snapshot) in
			if let userInfoDict = snapshot.value as? [String : AnyObject] {
				lover = Lover(dictionary: userInfoDict)
			}
		}, withCancel: nil)
		return lover
	}

	func getMultipleLovers(uids: [String]) -> [Lover] {
		var lovers = [Lover]()
		for uid in uids {
			Database.database().reference().child("lovers").child(uid).observe(.value, with: { (snapshot) in
				if let userInfoDict = snapshot.value as? [String : AnyObject] {
					let lover = Lover(dictionary: userInfoDict)
					lovers.append(lover)
				}
			}, withCancel: nil)
		}
		return lovers
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

//	func getAllLoversExceptCurrent() -> [Lover]{
//		var lovers = [Lover]()
//		Database.database().reference().child("lovers").observe(.childAdded, with: { (snapshot) in
//			if let dict = snapshot.value as? [String: AnyObject]{
//				let lover = Lover(dictionary: dict)
//				lover.id = snapshot.key
//				if lover.id != Auth.auth().currentUser?.uid {
//					lovers.append(lover)
//				}
//			}
//		}, withCancel: nil)
//		return lovers
//	}

	public func updateName(name: String) {
		guard let currentUser = AuthUserService.getCurrentUser() else {print("No user authenticated"); return}
		DBService.manager.getLoversRef().child(currentUser.uid).updateChildValues(["name": name])
	}

	public func updateEmail(email: String) {
		guard let currentUser = AuthUserService.getCurrentUser() else {print("No user authenticated"); return}
		DBService.manager.getLoversRef().child(currentUser.uid).updateChildValues(["email": email])
	}

	public func updatePhoto(profileImageUrl: String) {
		guard let currentUser = AuthUserService.getCurrentUser() else {print("No user authenticated"); return}
		DBService.manager.getLoversRef().child(currentUser.uid).updateChildValues(["profileImageUrl": profileImageUrl])
	}



}


