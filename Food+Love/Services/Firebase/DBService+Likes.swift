//
//  DBService+Likes.swift
//  Food+Love
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension DBService {
    func getUsersYouLikes(fromLover lover: Lover, completionHandler: @escaping ([Lover]?) -> Void) {
        if let userUids = lover.likedUsers {
        let users = DBService.manager.getMultipleLovers(uids: userUids)
            completionHandler(users)
        } else {
            completionHandler(nil)
        }
}
    // current user likes someone
    func addToCurrentUserLikes(fromCurrentUser currentUser: Lover, toLover: Lover) {
        let ref = DBService.manager.getLoversRef()
        guard let uid = currentUser.id else {return}
        var likedUsers = [String]()
        ref.child(uid).child("likedUsers").observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: String] {
             likedUsers = Array(dict.values)
            likedUsers.append(toLover.id!)
            }
        }
        ref.child(uid).child("likedUsers").setValue(likedUsers)
    }
    
    func getUsersLikedYou(ofCurrentUser currentUser: Lover, completionHandler: @escaping ([Lover]?) -> Void) {
        if let userUids = currentUser.usersThatLikeYou {
            let users = DBService.manager.getMultipleLovers(uids: userUids)
            completionHandler(users)
        } else {
            completionHandler(nil)
        }
    }
    // current user dislike someone
    func removeFromCurrentUserLikes(fromCurrentUser currentUser: Lover, toLover: Lover) {
        let ref = DBService.manager.getLoversRef()
        guard let uid = currentUser.id else {return}
        var likedUsers = [String]()
        ref.child(uid).child("likedUsers").observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String: String] {
                likedUsers = Array(dict.values)
                let index = likedUsers.index(where: {toLover.id! == $0})
                if index != nil {
                    likedUsers.remove(at: index!)
                }
            }
        }
        ref.child(uid).child("likedUsers").setValue(likedUsers)
    }
    
    func getMatches(forCurrentUser currentUser: Lover) -> [Lover] {
        var matches = [Lover]()
        var uids = [String]()
        guard currentUser.usersThatLikeYou != nil, currentUser.likedUsers != nil else {return []}
        for userUid in currentUser.usersThatLikeYou! {
            if currentUser.likedUsers!.contains(userUid) {
                uids.append(userUid)
            }
        }
       matches = DBService.manager.getMultipleLovers(uids: uids)
        return matches
    }
    
}
