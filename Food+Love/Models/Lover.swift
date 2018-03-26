
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
	var profileVideoUrl: String?
	var dateOfBirth: String?
	var zipcode: String?
	var city: String?
	var bio: String?
	var gender: String?
	var genderPreference: String?
	var smoke: String?
	var drink: String?
	var drugs: String?
	var favRestaurants: [String]?
	var likedUsers: [String]?
	var usersThatLikeYou: [String]?


	init(dictionary: [String: AnyObject]) {
		self.id = dictionary["id"] as? String
		self.name = dictionary["name"]  as? String
		self.email = dictionary["email"] as? String
		self.profileImageUrl = dictionary["profileImageUrl"]  as? String
		self.profileVideoUrl = dictionary["profileVideoUrl"]  as? String
		self.dateOfBirth = dictionary["dateOfBirth"]  as? String
		self.zipcode = dictionary["zipcode"]  as? String
		self.city = dictionary["city"]  as? String
		self.bio = dictionary["bio"]  as? String
		self.gender = dictionary["gender"]  as? String
		self.genderPreference = dictionary["genderPreference"]  as? String
		self.smoke = dictionary["smoke"]  as? String
		self.drink = dictionary["drink"]  as? String
		self.drugs = dictionary["drugs"]  as? String
		self.favRestaurants = dictionary["favRestaurants"]  as? [String]
		self.likedUsers = dictionary["likedUsers"]  as? [String]
		self.usersThatLikeYou = dictionary["usersThatLikeYou"]  as? [String]
	}

	init(id: String,
			 name: String,
			 email: String,
			 profileImageUrl: String,
			 profileVideoUrl: String?,
			 dateOfBirth: String?,
			 zipcode: String?,
			 city: String?,
			 bio: String?,
			 gender: String?,
			 genderPreference: String?,
			 smoke: String?,
			 drink: String?,
			 drugs: String?,
			 favRestaurants: [String]?,
			 likedUsers: [String]?,
			 usersThatLikeYou: [String]?
		){
		self.id = id
		self.name = name
		self.email = email
		self.profileImageUrl = profileImageUrl
		self.profileVideoUrl = profileVideoUrl
		self.dateOfBirth = dateOfBirth
		self.zipcode = zipcode
		self.city = city
		self.bio = bio
		self.gender = gender
		self.genderPreference = genderPreference
		self.smoke = smoke
		self.drink = drink
		self.drugs = drugs
		self.favRestaurants = favRestaurants
		self.likedUsers = likedUsers
		self.usersThatLikeYou = usersThatLikeYou
	}
}



