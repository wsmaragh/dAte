//
//  DBService+Likes.swift
//  Food+Love
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


extension DBService {
    func getUserFollowings(fromLover lover: Lover, completionHandler: @escaping ([Lover]?) -> Void) {
        var lovers = [Lover]()
        if let userUids = lover.following?.values {
            let usersArr = Array(userUids)
            for uid in usersArr {
      Database.database().reference().child("lovers").child(uid).observe(.value, with: { (snapshot) in
                    if let loverInfoDict = snapshot.value as? [String : AnyObject] {
                        let lover = Lover(dictionary: loverInfoDict)
                        lovers.append(lover)
                    }
                })
            }
            completionHandler(lovers)
        }
}
    // current user likes someone
    func addToCurrentUserLikes(fromCurrentUser currentUser: Lover, toLover: Lover, completionHandler: @escaping (Error?) -> Void) {
        let ref = DBService.manager.getLoversRef()
        let uid = currentUser.id
        var likedUsers = [String]()
        ref.child(uid).child("likedUsers").observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: String] {
             likedUsers = Array(dict.values)
            likedUsers.append(toLover.id)
                ref.child(uid).child("likedUsers").setValue(likedUsers)
                completionHandler(nil)

            }
        }
        ref.child(uid).child("likedUsers").child("0").setValue(uid)
        completionHandler(nil)
    }
    
    func getFollowers(ofCurrentUser currentUser: Lover, completionHandler: @escaping (Lover?) -> Void) {
        if let userUids = currentUser.followers?.values {
            let usersArr = Array(userUids)
            var lovers = [Lover]()
            for uid in usersArr {
//                let users = Database.database().reference().child("lovers").queryEqual(toValue: uid)
             
    Database.database().reference().child("lovers").child(uid).observe(.value) { (snapshot) in
                    var lover: Lover?

                    //   let snap = snapshot.value as! DataSnapshot
                    if let infoDict = snapshot.value as? [String: AnyObject] {
                        lover = Lover(dictionary: infoDict)
                        lovers.append(lover!)
                    }
                }
            
            }
        }
    }
    // current user dislike someone
    func removeFromCurrentUserLikes(fromCurrentUser currentUser: Lover, toLover: Lover, completionHandler: @escaping () -> Void) {
        let ref = DBService.manager.getLoversRef()
        let uid = currentUser.id
        var likedUsers = [String]()
        ref.child(uid).child("likedUsers").observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: String] {
                likedUsers = Array(dict.values)
							let index = likedUsers.index(where: {toLover.id == $0})
                if index != nil {
                    likedUsers.remove(at: index!)
                    completionHandler()
                }
            }
        }
        ref.child(uid).child("likedUsers").setValue(likedUsers)
    }
    
    
//    func getMatches(forCurrentUser currentUser: Lover) -> [Lover] {
//        var matches = [Lover]()
//        var uids = [String]()
//        guard currentUser.followers != nil, currentUser.following != nil else {return []}
//        for (ke, userUid) in currentUser.followers! {
//            if currentUser.following![ke] == userUid {
//                uids.append(userUid)
//            }
//        }
//    
//        return matches
//    }
    
}

