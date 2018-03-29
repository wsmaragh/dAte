
//  NetworkHelper.swift
//  Food+Love
//  Created by Winston Maragh on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit


//HTTP
enum HTTPVerb: String {
	case GET //Read
	case POST //Create
	case DELETE //Delete
	case PUT //Update/Replace
	case PATCH //Update/Modify
}

//AppError for Errorhandling
enum AppError: Error {
	case badData
	case badURL
    case badChildren
    case noUserExist
	case unauthenticated
	case codingError(rawError: Error)
	case invalidJSONResponse
	case couldNotParseJSON(rawError: Error)
	case noInternetConnection
	case badStatusCode
	case noDataReceived
	case notAnImage
	case other(rawError: Error)
}

//NetworkHelper - turns URL into Data
struct NetworkHelper {
	//Singleton
	private init(){}
	static let manager = NetworkHelper()

	//Create an instance of a URLSession
	private let session = URLSession(configuration: .default)

	//use URL to get Data
	func performDataTask(withURL url: URL,
											 completionHandler: @escaping (Data)->Void,
											 errorHandler: @escaping (AppError)->Void){

		let task =	session.dataTask(with: url) {(data, response, error) in
			DispatchQueue.main.async {
				guard let data = data else {errorHandler(AppError.badData); return}
				if let error = error {
					errorHandler(AppError.other(rawError: error))
				}
				completionHandler(data)
			}
		}
		task.resume()
	}

	//use URLRequest to get Data
	func performDataTask(withURLRequest urlRequest: URLRequest,
											 completionHandler: @escaping (Data) -> Void,
											 errorHandler: @escaping (Error) -> Void) {
		let task = session.dataTask(with: urlRequest){(data, response, error) in
			DispatchQueue.main.async {
				guard let data = data else {errorHandler(AppError.badData); return}
				if let error = error {
					errorHandler(AppError.other(rawError: error))
				}
				completionHandler(data)
			}
		}
		task.resume()
	}
}

//Image Helper - get images from online
struct ImageHelper {
	private init() {}
	static let manager = ImageHelper()
   let imageCache = NSCache<NSString, UIImage>()
	func getImage(from urlStr: String,
								completionHandler: @escaping (UIImage) -> Void,
								errorHandler: @escaping (AppError) -> Void) {

		guard let url = URL(string: urlStr) else { errorHandler(.badURL); return}

		//Check if data already exists
		if let savedImage = FileManagerHelper.manager.getUIImage(with: urlStr) {
			completionHandler(savedImage)
			return
		}
       //check cache for image first

        if let cachedImage = imageCache.object(forKey: urlStr as NSString)
        {
            completionHandler(cachedImage)
            return 
        }
		//Do completion only on first run, if it already exist do nothing.
		let completion: (Data) -> Void = {(data: Data) in
			guard let onlineImage = UIImage(data: data) else {return}
			//Save Image to FileManager
			FileManagerHelper.manager.saveUIImage(with: urlStr, image: onlineImage)
            
            // cach image
            self.imageCache.setObject(onlineImage, forKey: urlStr as NSString)
            
			completionHandler(onlineImage) //call completionHandler
		}

		NetworkHelper.manager.performDataTask(withURL: url, completionHandler: completion, errorHandler: errorHandler)

		func performDataTask(withURL url: URL,
												 completionHandler: @escaping (Data)->Void,
												 errorHandler: @escaping (AppError)->Void){

			let task =	URLSession().dataTask(with: url) {(data, response, error) in
				DispatchQueue.main.async {
					guard let data = data else {errorHandler(AppError.badData); return}
					if let error = error {
						errorHandler(AppError.other(rawError: error))
					}
					completionHandler(data)
				}
			}
			task.resume()
		}
	}
}



