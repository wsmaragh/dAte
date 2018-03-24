
//  StorageService.swift
//  Food+Love
//  Created by Winston Maragh on 3/15/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Firebase


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
		guard let data = UIImageJPEGRepresentation(image, 0.1) else { print("image is nil"); return }
		let metadata = StorageMetadata()
		metadata.contentType = "image/jpeg"

		//create UploadTask
		let uploadTask = StorageService.manager.getImagesRef().child(id).putData(data, metadata: metadata) { (storageMetadata, error) in
			if let error = error { print("uploadTask error: \(error)") }
			else if let storageMetadata = storageMetadata { print("storageMetadata: \(storageMetadata)") }
		}

		uploadTask.observe(.success) { snapshot in
			guard let imageURL = snapshot.metadata?.downloadURL() else { return }
			let imageStr = String(describing: imageURL)
			DBService.manager.updatePhoto(profileImageUrl: imageStr)
			AuthUserService.manager.updatePhoto(urlString: imageStr)
		}

	}
}

