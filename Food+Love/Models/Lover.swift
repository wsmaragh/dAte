
//  Lover.swift
//  Food+Love
//  Created by Winston Maragh on 3/16/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit

class Lover: NSObject {
	var id: String?
	var name: String?
	var email: String?
	var profileImageUrl: String?

	init(dictionary: [String: AnyObject]) {
		self.id = dictionary["id"] as? String
		self.name = dictionary["name"]  as? String
		self.email = dictionary["email"] as? String
		self.profileImageUrl = dictionary["profileImageUrl"]  as? String
	}

	init(id: String, name: String, email: String, profileImageUrl: String){
		self.id = id
		self.name = name
		self.email = email
		self.profileImageUrl = profileImageUrl
	}
}


