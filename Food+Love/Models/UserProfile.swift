//
//  UserProfile.swift
//  Food+Love
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
struct UserProfile: Codable {
    let name: String
    let email: String
    let uid: String
    let gender: String
    let genderPreference: String
    let bio: String
    let dob: String
    let address: String
    let city: String
    let zipcode: Int
    let foodPreference: [String]  //
    let favoriteRes: String?
    let traits: [String]  // smoke, drink, have kids, drugs
    let profileImageUrl: String?
    let profileVideoUrl: String?
    
    
    func toJson() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        let object = try! JSONSerialization.jsonObject(with: jsonData, options: [])
        return object
    } // this will return UserProfile as [String: Any]
    
}
