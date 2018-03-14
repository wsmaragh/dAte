//
//  FourSquareAPIClient.swift
//  Food+Love
//
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation


// MARK: - FourSquare Search API Client
struct FourSquareSearchAPIClient {
	private init(){}
	static let manager = FourSquareSearchAPIClient()

	func getVenues(from search: String, coordinate: String?, near: String?, completion: @escaping (Error?, [Venue]?) -> Void) {

		var endpoint = ""
		if let near = near, near != "" {endpoint = "https://api.foursquare.com/v2/venues/search?near=\(near)&query=\(search)\(FourSquareAPIKeys.fourSquareAuthorization)"}
		else if let coordinate = coordinate {endpoint = "https://api.foursquare.com/v2/venues/search?ll=\(coordinate)&query=\(search)\(FourSquareAPIKeys.fourSquareAuthorization)"}

		guard let url = URL(string: endpoint) else {return}

		let task =  URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			if let error = error {completion(error, nil)}
			else if let data = data {
				do {
					let JSON = try JSONDecoder().decode(FourSquareSearchJSON.self, from: data)
					let venues = JSON.response.venues
					completion(nil, venues)
				}
				catch { print("Error processing data: \(error)") }
			}
		})
		task.resume()
	}
}
