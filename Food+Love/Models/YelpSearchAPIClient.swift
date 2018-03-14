//  YelpSearchAPIClient.swift
//  Food+Love
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.


//import Foundation
//import CoreLocation
//
//class YelpSearchAPIClient {
//
//	static func searchVenue(placename: String, address: String?, coordinate: CLLocationCoordinate2D?,  completion: @escaping (Error?, [Place]?) -> Void) {
//
//		var urlRequest: URLRequest!
//
//		// using an address
//		if let address = address {
//			let url = URL(string:"\(YelpAPIKeys.baseSearchURL)\(placename)&location=\(address)")
//			urlRequest = URLRequest(url: url!)
//		}
//		// use coordinate
//		else {
//			let url = URL(string:"\(YelpAPIKeys.baseSearchURL)\(placename)&latitude=\(coordinate?.latitude)&longitude=\(coordinate?.longitude)")
//			urlRequest = URLRequest(url: url!)
//		}
//
//		urlRequest.setValue("Bearer \(YelpAPIKeys.apiKey)", forHTTPHeaderField: "Authorization")
//		let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
//			if let error = error { completion(error, nil) }
//			else if let data = data {
//				do {
//					let decoder = JSONDecoder()
//					let results = try decoder.decode(Results.self, from: data)
//					let places = results.businesses // an array of places
//					completion(nil, places)
//				} catch {
//					print("decoding error: \(error)")
//					completion(error, nil)
//				}
//			}
//		}
//		task.resume()
//	}
//}
//
