
//  ImageService.swift
//  Food+Love
//  Created by Winston Maragh on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit

//Image Helper - get images from online
struct ImageService {
	private init() {}
	static let manager = ImageService()

	func getImage(from urlStr: String,
								completionHandler: @escaping (UIImage) -> Void,
								errorHandler: @escaping (AppError) -> Void) {

		guard let url = URL(string: urlStr) else { errorHandler(.badURL); return }

		URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			if error != nil {print(error); return}
			DispatchQueue.main.async(execute: {
				if let downloadedImage = UIImage(data: data!) {
					completionHandler(downloadedImage)
				}
			})
		}).resume()
	}
}


