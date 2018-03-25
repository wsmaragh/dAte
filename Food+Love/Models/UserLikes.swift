//
//  UserLikes.swift
//  Food+Love
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation

struct UserLike: Codable {
    let uid: [String: String]
    
    init(dictionary: [String: String]) {
        self.uid = dictionary
    }
    
    
}
