
//  FSPhoto.swift
//  Food+Love
//  Created by Winston Maragh on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation


/////////////////////////////////////////////
// MARK: Four Square JSON
struct FSPhotoObjectsJSON: Codable {
	let response: PhotoResponse
}

struct PhotoResponse: Codable {
	let photos: Photos
}

struct Photos: Codable {
	let count: Int //30 - # of photos
	let items: [PhotoObject]
}

struct PhotoObject: Codable {
	let id: String //"51b8f916498e6a8c16a329eb"
	let prefix: String //"https://igx.4sqi.net/img/general/"
	let suffix: String //"/26739064_mUxQ4CGrobFqwpcAIoX6YoAdH0xCDT4YAxaU6y65PPI.jpg"
	let width: Int // 612
	let height: Int // 612
	let visibility: String //"public"
	let source: Source
}

struct Source: Codable {
	let name: String? // "Instagram"
	let url: String? //"http://instagram.com"
}



/////////////////////////////////////////////
// MARK: - FourSquare Photo API Client
struct FSPhotoAPIClient {
	private init(){}
	static let manager = FSPhotoAPIClient()

	func getVenuePhotos(venueID: String, completion: @escaping (Error?, [PhotoObject]?) -> Void) {

		let endpoint = "https://api.foursquare.com/v2/venues/\(venueID)/photos?\(FourSquareAPIKeys.fourSquareAuthorization)"
		guard let url = URL(string: endpoint) else {return}

		let task =  URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			if let error = error {completion(error, nil)}
			else if let data = data {
				do {
					let JSON = try JSONDecoder().decode(FSPhotoObjectsJSON.self, from: data)
					let photoObjects = JSON.response.photos.items //Object
					completion(nil, photoObjects)
				}
				catch { print("Error processing data: \(error)") }
			}
		})
		task.resume()
	}
}
