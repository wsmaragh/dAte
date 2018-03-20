//  FourSquarePhotoAPIClient.swift
//  Food+Love
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation

// MARK: - FourSquare Photo API Client
struct FourSquarePhotoAPIClient {
	private init(){}
	static let manager = FourSquarePhotoAPIClient()

	func getVenuePhotos(venueID: String, completion: @escaping (Error?, [PhotoObject]?) -> Void) {

		let endpoint = "https://api.foursquare.com/v2/venues/\(venueID)/photos?\(FourSquareAPIKeys.fourSquareAuthorization)"
		guard let url = URL(string: endpoint) else {return}

		let task =  URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			if let error = error {completion(error, nil)}
			else if let data = data {
				do {
					let JSON = try JSONDecoder().decode(FourSquarePhotoObjectsJSON.self, from: data)
					let photoObjects = JSON.response.photos.items //Object
					completion(nil, photoObjects)
				}
				catch { print("Error processing data: \(error)") }
			}
		})
		task.resume()
	}
}
