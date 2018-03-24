
//  FileManager.swift
//  Food+Love
//  Created by Winston Maragh on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit


class FileManagerHelper{
	private init(){}
	static let manager = FileManagerHelper()

	//MARK: FileName
	let filePathName = "Venues.plist"
	let datesPathName = "Dates.plist"
	let matchesPathName = "Matches.plist"


	//MARK: Variables
	private var venues = [Venue]() {
		didSet {
			saveData()
		}
	}


	// MARK: Documents Folder
	//returns supplied path name in documents directory
	func dataFilePath(pathName: String)->URL {
		let path = FileManagerHelper.manager.documentDirectory()
		//		print(FileManagerHelper.manager.documentDirectory()) //print file name
		return path.appendingPathComponent(pathName)
	}
	//returns Documents directory path for the App
	func documentDirectory()->URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0] //the 0 is the document folder
	}


	// MARK: Codable - to sandbox
	//Encode and Save
	private func saveData() {
		do {
			let encodedData = try PropertyListEncoder().encode(venues)
			let phoneURL = dataFilePath(pathName: filePathName)
			try encodedData.write(to: phoneURL, options: .atomic)
		}
		catch {print(error.localizedDescription)}
	}
	//Decode and Load
	func loadData() {
		do {
			let phoneURL = dataFilePath(pathName: filePathName)
			let encodedData = try Data(contentsOf: phoneURL)
			let savedVenues = try PropertyListDecoder().decode([Venue].self, from: encodedData)
			venues = savedVenues
		}
		catch {print(error.localizedDescription)}
	}


	// MARK: Actions
	func add(newVenue: Venue) {
		venues.insert(newVenue, at: 0)
	}
	func getAll() -> [Venue] {
		return venues
	}
	func deleteAll(){
		venues.removeAll()
	}
	func delete(index: Int) {
		venues.remove(at: index)
	}

	//Saving UIImage To Disk, with filepath as key
	func saveUIImage(with urlStr: String, image: UIImage) {
		let imageData = UIImagePNGRepresentation(image) //turn image to data
		let imagePathName = urlStr.components(separatedBy: "/").last! //use url string as file name to save
		let url = dataFilePath(pathName: imagePathName) //turn into URL
		do {
			try imageData?.write(to: url)
		}
		catch {print(error)}
	}

	//Retrieve UIImage from Disk, with filepath as key
	func getUIImage(with urlStr: String) -> UIImage? {
		do {
			let imagePathName = urlStr.components(separatedBy: "/").last!
			let url = dataFilePath(pathName: imagePathName)
			let data = try Data(contentsOf: url)
			return UIImage(data: data)
		}
		catch {print(error); return nil}
	}

	//	Remove Image from Documents directory
	func RemoveImageFromDisk(with key: String)->Bool {
		let imageURL = FileManagerHelper.manager.dataFilePath(pathName: key)
		do {
			try FileManager.default.removeItem(at: imageURL)
			return true
		}
		catch {print("error removing: \(error)"); return false}
	}

}







