
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
        profileImagesRef = storageRef.child("profile images")
	}
	static let manager = StorageService()

	private var storage: Storage!
	private var storageRef: StorageReference!
    private var profileImagesRef: StorageReference!
    private var profileVideoRef: StorageReference!
    private var chatImagesRef: StorageReference!
    private var chatVideoRef: StorageReference!

	public func getStorageRef() -> StorageReference { return storageRef }
    public func getProfileImagesRef() -> StorageReference { return profileImagesRef }
    public func getProfileVideoRef() -> StorageReference { return profileVideoRef }
    public func getChatImagesRef() -> StorageReference { return chatImagesRef }
    public func getChatVideoRef() -> StorageReference { return chatVideoRef }
    
}


//Store User Image
//extension StorageService {
//    public func storeUserImage(image: UIImage) {
//        let user = AuthUserService.getCurrentUser()
//        guard let id = user?.uid else {return}
//
//        guard let data = UIImageJPEGRepresentation(image, 1.0) else { print("image is nil"); return }
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        //create UploadTask
//        let uploadTask = StorageService.manager.getImagesRef().child((user?.uid)!).putData(data, metadata: metadata) { (storageMetadata, error) in
//            if let error = error { print("uploadTask error: \(error)") }
//            else if let storageMetadata = storageMetadata { print("storageMetadata: \(storageMetadata)") }
//        }
//
//        uploadTask.observe(.success) { snapshot in
//            guard let imageURL = snapshot.metadata?.downloadURL() else { return }
//            let imageStr = String(describing: imageURL)
//            DBService.manager.updateUserImage(profileImageUrl: imageStr)
//            AuthUserService.manager.changeAuthProfilePhoto(urlString: imageStr)
//        }
//
//    }
//}

