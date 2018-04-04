
//  DBService.swift
//  Food+Love
//  Created by Winston Maragh on 3/15/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import FirebaseDatabase
import FirebaseAuth


class DBService {

	static let manager = DBService()

	private init(){
		dbRef = Database.database().reference()
		loversRef = dbRef.child("lovers")
		conversationsRef = dbRef.child("conversations")
		messagesRef = dbRef.child("messages")
		categoriesRef = dbRef.child("categories")
	}

	// MARK: Properties
	private var dbRef: DatabaseReference!
	private var loversRef: DatabaseReference!
	private var conversationsRef: DatabaseReference!
	private var messagesRef: DatabaseReference!
	private var categoriesRef: DatabaseReference!

	// MARK: Helper Methods
	public func getDBRef()-> DatabaseReference { return dbRef }
	public func getLoversRef()-> DatabaseReference { return loversRef }
	public func getConversationsRef()-> DatabaseReference { return conversationsRef }
	public func getMessagesRef()-> DatabaseReference { return messagesRef }
	public func getCategoriesRef()-> DatabaseReference {return categoriesRef}


	// Format date
	public func formatDateforMessages(with date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, YYYY h:mm a"
		return dateFormatter.string(from: date)
	}

	public func formatDateforDOB(with date: Date) -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MMM d, YYYY"
		return dateFormatter.string(from: date)
	}
	
}


