
//  YelpAPIKeys.swift
//  Food+Love
//  Created by Winston Maragh on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation


struct YelpAPIKeys {
	static let todaysDate = Date().description.prefix(10).replacingOccurrences(of: "-", with: "")
	static let apiKey = "vmHFC42Yuh-HoSi3pwieDo5uxAp0o8urO6RS2cYMXZhzUBZXyAr3IaQE8iu_WlgNgiXnxXBNBqhDSwI5iEUYOGY5_ceYqRDcjcSCwQCDk2ruWAyubT8cdQr5zwtiWnYx"
	static let baseSearchURL = "https://api.yelp.com/v3/businesses/search?term="

}
