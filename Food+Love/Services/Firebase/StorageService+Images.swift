//
//  StorageService+Images.swift
//  Food+Love
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import Foundation
import UIKit
import FirebaseStorage



//Store User Image
extension StorageService {

    func storeProfileImage(image: UIImage, userId: String, imageIndex: Int) {
        // convert image into data
        guard let data = UIImageJPEGRepresentation(image, 1.0) else {
            print("could not get image data")
            return
        }
        //store the image as data in the storage ref
        //create metadata object
        let metadata = StorageMetadata()
        var ref: StorageReference!
        //tell metadata that the data will be an image of type jpeg
        metadata.contentType = "image/jpeg"

        // find a unique key to store the image under, so it doesn't overwrite the image every time
        if imageIndex == 0 {
            ref = StorageService.manager.getImagesRef().child(userId).child("profileImage")
        } else {
         ref = StorageService.manager.getImagesRef().child(userId).child("profileImage\(imageIndex)")
        }
        //create the task that uploads (put) data or URL
        //you can get back metadata about the storage
        let uploadTask = ref.putData(data, metadata: metadata) { (storageMetadata, error) in
            if let error = error {
                print("uploadTask error: \(error)")
            } else if let storageMetadata = storageMetadata {
                print("storageMetadata = \(storageMetadata)")
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            let percentage = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
            print(percentage)
        }
        uploadTask.observe(.success) { (snapshot) in
            // Upload completed successfully
            // set job's imageURL
            let imageURL = String.init(describing: snapshot.metadata!.downloadURL()!)
            DBService.manager.updateProfileImages(profileImageUrl: imageURL, imageNum: imageIndex)
            //  DBService.manager.getPostsRef().child("\(postId)/imageURL").setValue(imageURL)


            // DBService.manager.getJobs().child("\(postId)").updateChildValues(["imageURL" :  imageURL])
        }
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error as NSError? {
                switch(StorageErrorCode(rawValue: error.code)!) {
                case .objectNotFound:
                    // File doesn't exist
                    break
                case .unauthorized:
                    // User doesn't have permission to access file
                    break
                case .cancelled:
                    // User canceled the upload
                    break

                    /* ... */

                case .unknown:
                    // Unknown error occurred, inspect the server response
                    break
                default:
                    // A separate error occurred. This is a good place to retry the upload.
                    break
                }
            }
        }
    }

}

