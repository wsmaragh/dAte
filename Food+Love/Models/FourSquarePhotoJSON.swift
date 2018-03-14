//  FourSquarePhotoJSON.swift
//  Food+Love
//  Created by C4Q on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation


struct FourSquarePhotoObjectsJSON: Codable {
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

