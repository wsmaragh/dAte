
//	FSSearchJSON.swift
//  Food+Love
//  Created by Winston Maragh on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation


//////////////////////////////////////////
// MARK: FourSquare Search Json
struct FSSearchJSON: Codable {
	let response: SearchResponse
}

struct SearchResponse: Codable {
	let venues: [Venue]
}

struct Venue: Codable {
	let id: String   //"4c12b1f277cea593a187cd60
	let name: String  //"Papa John's Pizza"
	let contact: Contact
	let location: Location
	let categories: [Category]
	let verified: Bool //true
	let url: String? //"http://www.papajohns.com"  (company website)
}

struct Contact:  Codable {
	let phone: String? //"5613957272"
	let formattedPhone: String? //"(561) 395-7272"
	let twitter: String? // "papajohns",
	let facebook: String? // "371362759726019",
	let facebookUsername: String? //  "papajohns",
	let facebookName: String? //  "Papa John's Pizza"
}

struct Location: Codable {
	let lat: Double // 26.354801369979633
	let lng: Double // -80.08546889823307
	let address: String? //"505 N Federal Hwy"
	let crossStreet: String?
	let distance: Double?
	let postalCode: String? //33432
	let cc: String? //US
	let city: String? //"Boca Raton"
	let state: String? //"FL"
	let country: String //"United States"
}

struct Category: Codable {
	let id: String //"4bf58dd8d48988d1ca941735"
	let name: String //"Pizza Place"
	let pluralName: String //"Pizza Places"
	let shortName: String //"Pizza"
	let icon: Icon
	struct Icon: Codable {
		let prefix: String? //"https://ss3.4sqi.net/img/categories_v2/food/pizza_"
		let suffix: String? //".png"
	}
	let primary: Bool //true    (primary category)
}

struct Delivery: Codable {
	let id: String?
	let url: String?
	let provider: Provider?
	struct Provider: Codable {
		let name: String?
	}
}


//////////////////////////////////////////
// MARK: - FourSquare Search API Client
struct FSSearchAPIClient {
    private init(){}
    static let manager = FSSearchAPIClient()
    
    func getVenues(lat: String,
                   long: String,
                   distance: String,
                   completion: @escaping ([Venue]?) -> Void,
                   errorHandler: @escaping (Error?) -> Void) {
        
        let baseURL = "https://api.foursquare.com/v2/venues/search?"
        let endpoint = "\(baseURL)ll=\(lat),\(long)&radius=\(distance)\(FourSquareAPIKeys.fourSquareAuthorization)"
        //let endpoint = "\(baseURL)ll=\(coordinate)&query=\(search)&radius=\(distance)\(FourSquareAPIKeys.fourSquareAuth)"
        guard let url = URL(string: endpoint) else {return}
        
        let parseData = {(data: Data?) in
            if let data = data {
                do {
                    let JSON = try JSONDecoder().decode(FSSearchJSON.self, from: data)
                    let venues = JSON.response.venues
                    completion(venues)
                } catch let error {
                    errorHandler(error)
                }
            }
        }
        NetworkHelper.manager.performDataTask(withURL: url, completionHandler: parseData, errorHandler: errorHandler)
    }
    
    func searchVenues(search: String,
                      lat: String,
                      long: String,
                      distance: String,
                      completion: @escaping ([Venue]?) -> Void,
                      errorHandler: @escaping (Error?) -> Void) {
        
        let baseURL = "https://api.foursquare.com/v2/venues/search?"
        let endpoint = "\(baseURL)ll=\(lat),\(long)&query=\(search)&radius=\(distance)\(FourSquareAPIKeys.fourSquareAuthorization)"
        //let endpoint = "\(baseURL)ll=\(coordinate)&query=\(search)&radius=\(distance)\(FourSquareAPIKeys.fourSquareAuth)"
        guard let url = URL(string: endpoint) else {return}
        
        let parseData = {(data: Data?) in
            if let data = data {
                do {
                    let JSON = try JSONDecoder().decode(FSSearchJSON.self, from: data)
                    let venues = JSON.response.venues
                    completion(venues)
                } catch let error {
                    errorHandler(error)
                }
            }
        }
        NetworkHelper.manager.performDataTask(withURL: url, completionHandler: parseData, errorHandler: errorHandler)
    }
//    private init(){}
//    static let manager = FSSearchAPIClient()
//
//    func getVenues(from search: String, coordinate: String?, near: String?, completion: @escaping (Error?, [Venue]?) -> Void) {
//
//        var endpoint = ""
//        if let near = near, near != "" {endpoint = "https://api.foursquare.com/v2/venues/search?near=\(near)&query=\(search)\(FourSquareAPIKeys.fourSquareAuthorization)"}
//        else if let coordinate = coordinate {endpoint = "https://api.foursquare.com/v2/venues/search?ll=\(coordinate)&query=\(search)\(FourSquareAPIKeys.fourSquareAuthorization)"}
//
//        guard let url = URL(string: endpoint) else {return}
//
//        let task =  URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
//            if let error = error {completion(error, nil)}
//            else if let data = data {
//                do {
//                    let JSON = try JSONDecoder().decode(FSSearchJSON.self, from: data)
//                    let venues = JSON.response.venues
//                    completion(nil, venues)
//                }
//                catch { print("Error processing data: \(error)") }
//            }
//        })
//        task.resume()
//    }
}

