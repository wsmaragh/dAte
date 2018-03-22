//  StorageService.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.


import UIKit
import Firebase
//import FirebaseStorage
//import FirebaseAuth

class StorageService {
	private init(){
		storage = Storage.storage()
		storageRef = storage.reference()
		imagesRef = storageRef.child("images")
	}
	static let manager = StorageService()

	private var storage: Storage!
	private var storageRef: StorageReference!
	private var imagesRef: StorageReference!

	public func getStorageRef() -> StorageReference { return storageRef }
	public func getImagesRef() -> StorageReference { return imagesRef }
}


//Store User Image
extension StorageService {
	public func storeUserImage(image: UIImage) {
		let user = AuthUserService.getCurrentUser()
		guard let id = user?.uid else {return}

		guard let data = UIImageJPEGRepresentation(image, 1.0) else { print("image is nil"); return }
		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"

		//create UploadTask
		let uploadTask = StorageService.manager.getImagesRef().child((user?.uid)!).putData(data, metadata: metadata) { (storageMetadata, error) in
			if let error = error { print("uploadTask error: \(error)") }
			else if let storageMetadata = storageMetadata { print("storageMetadata: \(storageMetadata)") }
		}

		uploadTask.observe(.success) { snapshot in
			guard let imageURL = snapshot.metadata?.downloadURL() else { return }
			let imageStr = String(describing: imageURL)

			//update userImage on Auth
//			let changeRequest = user?.createProfileChangeRequest()
//			changeRequest?.photoURL = imageURL
//			changeRequest?.commitChanges(completion: {(error) in
//				if let error = error { print("error changing userImage in Auth. Error: \(error)") }
//				else { print("user Image addes to Authenticated User: \(String(describing: user))") } //changes successful
//			})

			//update userImage on all posts (redundant if storing userImage in Auth)
			DBService.manager.updateUserImage(profileImageUrl: imageStr)
			AuthUserService.manager.changeAuthProfilePhoto(urlString: imageStr)


		}

	}
}

