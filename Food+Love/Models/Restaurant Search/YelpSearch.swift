
//  YelpSearch.swift
//  Food+Love
//  Created by Winston Maragh on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import CoreLocation


/////////////////////////////////////////
// MARK: Yelp Search JSON

//struct Category: Codable {
//	let alias: String
//	let title: String
//}
//
//struct Location: Codable {
//	let address1: String?
//	let address2: String?
//	let address3: String?
//	let city: String
//	let zipCode: String
//	let country: String
//	let state: String
//	let displayAddress: [String]
//
//	enum CodingKeys: String, CodingKey {
//		case address1
//		case address2
//		case address3
//		case city
//		case zipCode = "zip_code"
//		case country
//		case state
//		case displayAddress = "display_address"
//	}
//}
//
//struct Coordinate: Codable {
//	let latitude: Double
//	let longitude: Double
//}
//
//struct Place: Codable {
//	let id: String
//	let name: String
//	let imageURL: URL
//	let isClosed: Bool
//	let url: URL
//	let reviewCount: Int
//	let categories: [Category]
//	let rating: Double
//	let transactions: [String]
//	let price: String?
//	let location: Location?
//	let phone: String
//	let displayPhone: String
//	let distance: Double
//	let coordinates: Coordinate
//
//	enum CodingKeys: String, CodingKey {
//		case id
//		case name
//		case imageURL = "image_url"
//		case isClosed = "is_closed"
//		case url
//		case reviewCount = "review_count"
//		case categories
//		case rating
//		case transactions
//		case price
//		case location
//		case phone
//		case displayPhone = "display_phone"
//		case distance
//		case coordinates
//	}
//}
//
//struct Results: Codable {
//	let businesses: [Place]
//}



/////////////////////////////////////////
// MARK: Yelp Search API Client
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
