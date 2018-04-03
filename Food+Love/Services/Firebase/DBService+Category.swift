//
//  DBService+Category.swift
//  Food+Love
//
//  Created by C4Q on 3/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage


extension DBService {
//    func getAllFoodCategories(completionHandler: @escaping ([String]?) -> Void) {
//        let ref = DBService.manager.getCategoriesRef()
//
//        ref.observe(.value) { (snapshot) in
//           var categories = [String]()
//            for child in snapshot.children {
//                let dataSnapshot = child as! DataSnapshot
//                if let dict = dataSnapshot.value as? [String: Any] {
//                    guard let singleCategory = dict["title"] as? String else {continue}
//                    categories.append(singleCategory)
//                }
//            }
//            completionHandler(categories)
//
//        }
//
//
//}
    
    func getCategories(completion: @escaping ([String]) -> Void) {
        let ref = Database.database().reference().child("categories")
        ref.observe(.value) { (snapShot) in
            var categories = [String]()
            for child in snapShot.children {
                let cat = FoodCategory(snapShot: child as! DataSnapshot)
                let catName = cat.title
                categories.append(catName)
            }
            completion(categories)
        }
    }
}

//for child in snapshot.children {
//    let dataSnapshot = child as! DataSnapshot
//    if let dict = dataSnapshot.value as? [String: AnyObject] {
//        let lover = Lover.init(dictionary: dict)
//        lovers.append(lover)

