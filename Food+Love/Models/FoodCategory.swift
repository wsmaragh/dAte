//
//  Category.swift
//  Food+Love
//
//  Created by Marlon Rugama on 3/27/18.
//  Copyright © 2018 Marlon Rugama. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FoodCategory: Codable {
    let alias: String
    let title: String
    
    init(snapShot: DataSnapshot) {
        let dict = snapShot.value as! [String: Any]
        self.alias = dict["alias"] as? String ?? ""
        self.title = dict["title"] as? String ?? ""
    }
    
    init(alias: String, title: String) {
        self.alias = alias
        self.title = title
    }
    
    func toAnyObj() -> [String: Any] {
        return ["alias": alias,
                "title": title]
    }
}
