
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
	var profileImageUrl1: String?
	var profileImageUrl2: String?
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
	var following: [String: String]?
	var followers: [String: String]?
	var morePhotos: [String]?


	init(dictionary: [String: AnyObject]) {
		self.id = dictionary["id"] as? String ?? ""
		self.name = dictionary["name"] as? String ?? ""
		self.email = dictionary["email"] as? String ?? ""
		self.profileImageUrl = dictionary["profileImageUrl"]  as? String
		self.profileImageUrl1 = dictionary["profileImageUrl1"]  as? String
		self.profileImageUrl2 = dictionary["profileImageUrl2"]  as? String
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
		self.following = dictionary["following"]  as? [String: String]
		self.followers = dictionary["followers"]  as? [String: String]
		self.morePhotos = dictionary["morePhotos"] as? [String]
	}

	init(id: String,
			 name: String,
			 email: String,
       profileImageUrl: String?,
       profileImageUrl1: String?,
       profileImageUrl2: String?,
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
			 following: [String: String]?,
			 followers: [String: String]?,
			 morePhotos: [String]?
		){
		self.id = id
		self.name = name
		self.email = email
		self.profileImageUrl = profileImageUrl
        self.profileImageUrl1 = profileImageUrl1
        self.profileImageUrl2 = profileImageUrl2
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
        self.following = following
        self.followers = followers
        self.morePhotos = morePhotos
	}

	public func changeStringToDate(dateString: String) -> Date {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let date = dateFormatter.date(from: dateString)
		return date!
	}

	public func convertBirthDayToAge(dob: String) -> Int? {
		var myAge: Int?
		// let myDOB = Calendar.current.date(from: DateComponents(year: 1970, month: 9, day: 10))!
		let ageArr = dob.components(separatedBy: "-")
		let year =  Int(ageArr[0])
		let month = Int(ageArr[1])
		let day = Int(ageArr[2])
		let myDOB = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
		myAge = myDOB.age
		return myAge
	}

}



