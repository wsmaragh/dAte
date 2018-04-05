//
//  DBService+Lovers.swift
//  Food+Love
//
//  Created by C4Q on 3/31/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


// MARK: Lovers
extension DBService {
	// Add User main
	public func addLover(name: String, email: String, profileImage: UIImage) {
		let lover = DBService.manager.getLoversRef().child((Auth.auth().currentUser?.uid)!)
		lover.setValue(["name"     : name,
										"email"		: email])
		{ (error, dbRef) in
			if let error = error { print("addUser error: \(error.localizedDescription)")}
			else { print("user successfully added to database reference: \(dbRef)")}
		}
		StorageService.manager.storeUserImage(image: profileImage)
	}

	// Add Details
	public func addLoverDetails(favCat1: String,
															favCat2: String,
															favCat3: String,
															favRestaurant: String,
															zipcode: String,
															gender: String,
															genderPreference: String,
															dateOfBirth: String) {
		let lover = DBService.manager.getLoversRef().child((Auth.auth().currentUser?.uid)!)
		lover.setValue(["favCat1": favCat1,
										"favCat2": favCat2,
										"favCat3": favCat3,
										"favRestaurant": favRestaurant,
										"zipcode": zipcode,
										"gender" : gender,
										"genderPreference": genderPreference,
										"dateOfBirth": dateOfBirth
			])
		{ (error, dbRef) in
			if let error = error { print("addUser error: \(error.localizedDescription)")}
			else { print("user successfully added to database reference: \(dbRef)")}
		}
	}



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

	func getMultipleLovers(uids: [String]) -> [Lover] {
		var lovers = [Lover]()
		for uid in uids {
			Database.database().reference().child("lovers").child(uid).observe(.value, with: { (snapshot) in
				if let loverInfoDict = snapshot.value as? [String : AnyObject] {
					let lover = Lover(dictionary: loverInfoDict)
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

	func getAllLoversExceptCurrent() -> [Lover]{
		var lovers = [Lover]()
		Database.database().reference().child("lovers").observe(.childAdded, with: { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject]{
				let lover = Lover(dictionary: dict)
				lover.id = snapshot.key
				if lover.id != Auth.auth().currentUser?.uid {
					lovers.append(lover)
				}
			}
		}, withCancel: nil)
		return lovers
	}


	public func updateName(name: String) {
		guard let currentUser = AuthService.getCurrentUser() else {print("No user authenticated"); return}
		DBService.manager.getLoversRef().child(currentUser.uid).updateChildValues(["name": name])
	}

	public func updateEmail(email: String) {
		guard let currentUser = AuthService.getCurrentUser() else {print("No user authenticated"); return}
		DBService.manager.getLoversRef().child(currentUser.uid).updateChildValues(["email": email])
	}

	public func updatePhoto(profileImageUrl: String) {
		guard let currentUser = AuthService.getCurrentUser() else {print("No user authenticated"); return}
		DBService.manager.getLoversRef().child(currentUser.uid).updateChildValues(["profileImageUrl": profileImageUrl])
	}
	public func updateProfileImages(profileImageUrl: String, imageNum: Int) {
		guard let currentUser = AuthService.getCurrentUser() else {print("No user authenticated"); return}
		if imageNum == 0 {DBService.manager.getLoversRef().child(currentUser.uid).updateChildValues(["profileImageUrl": profileImageUrl])
		} else { DBService.manager.getLoversRef().child(currentUser.uid).updateChildValues(["profileImageUrl\(imageNum)": profileImageUrl])
		}
	}
	public func updateEditedProfileInfo(ediedDict: [String: Any?]) {
		guard let currentUser = AuthService.getCurrentUser() else {print("No user authenticated"); return}
		for (key, value) in ediedDict { DBService.manager.getLoversRef().child(currentUser.uid).updateChildValues([key: value])
		}
	}



}
