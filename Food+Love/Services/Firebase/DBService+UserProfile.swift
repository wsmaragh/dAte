//
//  DBService+UserProfile.swift
//  Food+Love
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


//extension DBService {
//    func createUserProfile(uid: String, userProfileDict: [String: Any]) {
//        let ref = getUserProfileRef()
//        ref.child(uid).setValue(userProfileDict)
//    }
//
//    func getAllUserProfiles(completionHandler: @escaping([UserProfile]?, Error?) -> Void) {
//        let ref = getUserProfileRef()
//        ref.observe(.value) { (snapshot) in
//            guard let childSnapshots = snapshot.children.allObjects as? [DataSnapshot] else {
//                completionHandler(nil, AppError.badChildren)
//                return
//            }
//            var users = [UserProfile]()
//            for childSnapshot in childSnapshots {
//                guard let rawJson = childSnapshot.value else {continue}
//                do {
//                    let jsonData = try JSONSerialization.data(withJSONObject: rawJson, options: [])
//                    let userProfile = try JSONDecoder().decode(UserProfile.self, from: jsonData)
//                    users.append(userProfile)
//                } catch {
//                    print("decoding userProfile JSON error: \(error)")
//                    completionHandler(nil, error)
//                    return
//                }
//                completionHandler(users, nil)
//            }
//        }
//    }
//
//    func updateUserProfile(uid: String, userProfileDict: [String: Any]) {
//        let ref = getUserProfileRef()
//        ref.updateChildValues(userProfileDict)
//    }
//
//    func deleteUser(uid: String) {
//        let ref = getUserProfileRef()
//        ref.removeValue { (error, dbRef) in
//            if let error = error {
//                print("remove userProfile error: \(error)")
//                return
//            }
//        }
//    }
//
//
//}

