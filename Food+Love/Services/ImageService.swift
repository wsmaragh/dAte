
//  ImageService.swift
//  Food+Love
//  Created by Winston Maragh on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit

//Image Helper - get images from online
//struct ImageService {
//	private init() {}
//	static let manager = ImageHelper()
//
//	func getImage(from urlStr: String,
//								completionHandler: @escaping (UIImage) -> Void,
//								errorHandler: @escaping (AppError) -> Void) {
//
//		guard let url = URL(string: urlStr) else { errorHandler(.badURL); return }
//
//		//Check if data already exists
//		if let savedImage = FileManagerHelper.manager.getUIImage(with: urlStr) {
//			completionHandler(savedImage)
//			return
//		}
//
//		//Network call to get image
//		Alamofire.request(url).responseData { (response) in
//			guard response.result.isSuccess else { fatalError("This url don't work bruh") }
//			guard let data = response.data else { fatalError("where the data at") }
//			guard let image = UIImage(data: data) else { fatalError("where the image at") }
//
//			//Save to Filemanager
//			FileManagerHelper.manager.saveUIImage(with: urlStr, image: image) //Is this always persisted and why?
//			completionHandler(image)
//		}
//	}
//}
//

