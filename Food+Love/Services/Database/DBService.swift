//  DBService.swift
//  POSTR2.0
//  Created by Winston Maragh on 2/2/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.


import Foundation
import FirebaseDatabase


class DBService {

	//MARK: Properties
	private var dbRef: DatabaseReference!
	private var loversRef: DatabaseReference!
	private var imagesRef: DatabaseReference!


	private init(){
		// reference to the root of the Firebase database
		dbRef = Database.database().reference()

		// children of root database node
		loversRef = dbRef.child("lovers")
		imagesRef = dbRef.child("images")
	}
	static let manager = DBService()

    public func formatDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY h:mm a"
        return dateFormatter.string(from: date)
    }

	public func getDB()-> DatabaseReference { return dbRef }
	public func getLovers()-> DatabaseReference { return loversRef }
	public func getImages()-> DatabaseReference { return imagesRef }
}
