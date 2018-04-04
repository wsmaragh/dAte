
//  Lover.swift
//  Food+Love
//  Created by Winston Maragh on 3/16/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.


import UIKit

class Lover: NSObject {
	var id: String
	var name: String
	var email: String
	var profileImageUrl: String?
	var morePhotos: [String]?
	var dateOfBirth: String?
	var zipcode: String?
	var city: String?
	var bio: String?
	var gender: String?
	var genderPreference: String?
	var favDish: String?
	var favDishImageUrl: String?
	var firstFoodPrefer: String?
	var secondFoodPrefer: String?
	var thirdFoodPrefer: String?
	var favRestaurants: [String]?
	var likedUsers: [String]?
	var usersThatLikeYou: [String]?

	init(dictionary: [String: AnyObject]) {
		self.id = dictionary["id"] as? String ?? ""
		self.name = dictionary["name"] as? String ?? ""
		self.email = dictionary["email"] as? String ?? ""
		self.profileImageUrl = (dictionary["profileImageUrl"]  as? String)!
		self.morePhotos = dictionary["morePhotos"] as? [String]
		self.dateOfBirth = dictionary["dateOfBirth"]  as? String
		self.zipcode = dictionary["zipcode"]  as? String
		self.city = dictionary["city"]  as? String
		self.bio = dictionary["bio"]  as? String
		self.gender = dictionary["gender"]  as? String
		self.genderPreference = dictionary["genderPreference"]  as? String
		self.favDish = dictionary["favDish"] as? String
		self.favDishImageUrl = dictionary["favDishImageUrl"] as? String
		self.firstFoodPrefer = dictionary["firstFoodPrefer"] as? String
		self.secondFoodPrefer = dictionary["secondFoodPrefer"] as? String
		self.thirdFoodPrefer = dictionary["thirdFoodPrefer"] as? String
		self.favRestaurants = dictionary["favRestaurants"]  as? [String]
		self.likedUsers = dictionary["likedUsers"]  as? [String]
		self.usersThatLikeYou = dictionary["usersThatLikeYou"]  as? [String]
	}

	init(id: String,
			 name: String,
			 email: String,
       profileImageUrl: String?,
			 morePhotos: [String]?,
			 profileVideoUrl: String?,
			 dateOfBirth: String?,
			 zipcode: String?,
			 city: String?,
			 bio: String?,
			 gender: String?,
			 genderPreference: String?,
			 favDish: String?,
			favDishImageUrl: String?,
			firstFoodPrefer: String?,
			secondFoodPrefer: String?,
			 thirdFoodPrefer: String?,
			 favRestaurants: [String]?,
			 likedUsers: [String]?,
			 usersThatLikeYou: [String]?
		){
		self.id = id
		self.name = name
		self.email = email
		self.profileImageUrl = profileImageUrl
		self.morePhotos = morePhotos
		self.dateOfBirth = dateOfBirth
		self.zipcode = zipcode
		self.city = city
		self.bio = bio
		self.gender = gender
		self.genderPreference = genderPreference
        self.favDish = favDish
        self.favDishImageUrl = favDishImageUrl
        self.firstFoodPrefer = firstFoodPrefer
        self.secondFoodPrefer = secondFoodPrefer
        self.thirdFoodPrefer = thirdFoodPrefer
		self.favRestaurants = favRestaurants
		self.likedUsers = likedUsers
		self.usersThatLikeYou = usersThatLikeYou
	}

	public func changeStringToDate(dateString: String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let date = dateFormatter.date(from: dateString)
		return date!
	}

}



