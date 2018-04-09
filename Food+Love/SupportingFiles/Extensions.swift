//  Extensions.swift
//  Food+Love
//  Created by C4Q on 3/16/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import UIKit
import ImageIO


class RoundedImageView: UIImageView {
	override func layoutSubviews() {
		super.layoutSubviews()
		let radius: CGFloat = self.bounds.size.width / 2.0
		self.layer.cornerRadius = radius
		self.clipsToBounds = true
	}
}

extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}


// Dictionary
extension Dictionary {
	mutating func merge(with dictionary: Dictionary) {
		dictionary.forEach { updateValue($1, forKey: $0) }
	}

	func merged(with dictionary: Dictionary) -> Dictionary {
		var dict = self
		dict.merge(with: dictionary)
		return dict
	}
}

// Image Cache
let imageCache = NSCache<AnyObject, AnyObject>()


// Extend UICOLOR
extension UIColor {
	convenience init(hex:Int, alpha:CGFloat = 1.0) {
		self.init(
			red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
			green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
			blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
			alpha: alpha
		)
	}
	
	convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
		self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
	}
}

// Extend UIViewController
extension UIViewController {
	static func storyboardInstance(storyboardName: String, viewControllerIdentifiier: String) -> UIViewController {
		let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
		let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerIdentifiier)
		return viewController
	}
}

// Extend UITEXTFIELD
extension UITextField {
	func underlined(color: UIColor){
		self.borderStyle = UITextBorderStyle.none
		self.backgroundColor = UIColor.clear
		let border = CALayer()
		let width = CGFloat(1.0)
		border.borderColor = color.cgColor
		border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
		border.borderWidth = width
		self.layer.addSublayer(border)
		self.layer.masksToBounds = true
	}
	func setBottomLine() {
		self.borderStyle = UITextBorderStyle.none
		self.backgroundColor = UIColor.clear

		let borderLine = UIView()
		let height = 1.0
		borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
		borderLine.backgroundColor = UIColor.white
		self.addSubview(borderLine)
	}
}



// Extend  IMAGEVIEW
extension UIImageView {
	//Image Cache
	func loadImageUsingCacheWithUrlString(_ urlString: String) {
//        DispatchQueue.main.async {
        self.image = nil
//        }
     
		//check cache for image first
		if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
			self.image = cachedImage
			return
		}
		//otherwise download
		guard let url = URL(string: urlString) else {return}
		URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
			//download hit an error so lets return out
			if let error = error {
				print(error)
				return
			}
			DispatchQueue.main.async(execute: {
				if let downloadedImage = UIImage(data: data!) {
					imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
					self.image = downloadedImage
				}
			})
		}).resume()
	}
}



// Extend IMAGE
extension UIImage {

	public class func gifImageWithData(_ data: Data) -> UIImage? {
		guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
			print("image doesn't exist")
			return nil
		}

		return UIImage.animatedImageWithSource(source)
	}

	public class func gifImageWithURL(_ gifUrl:String) -> UIImage? {
		guard let bundleURL:URL = URL(string: gifUrl)
			else {
				print("image named \"\(gifUrl)\" doesn't exist")
				return nil
		}
		guard let imageData = try? Data(contentsOf: bundleURL) else {
			print("image named \"\(gifUrl)\" into NSData")
			return nil
		}

		return gifImageWithData(imageData)
	}

	public class func gifImageWithName(_ name: String) -> UIImage? {
		guard let bundleURL = Bundle.main
			.url(forResource: name, withExtension: "gif") else {
				print("SwiftGif: This image named \"\(name)\" does not exist")
				return nil
		}
		guard let imageData = try? Data(contentsOf: bundleURL) else {
			print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
			return nil
		}

		return gifImageWithData(imageData)
	}

	class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
		var delay = 0.1

		let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
		let gifProperties: CFDictionary = unsafeBitCast(
			CFDictionaryGetValue(cfProperties,
													 Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
			to: CFDictionary.self)

		var delayObject: AnyObject = unsafeBitCast(
			CFDictionaryGetValue(gifProperties,
													 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
			to: AnyObject.self)
		if delayObject.doubleValue == 0 {
			delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
																											 Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
		}

		delay = delayObject as! Double

		if delay < 0.1 {
			delay = 0.1
		}

		return delay
	}

	class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
		var a = a
		var b = b
		if b == nil || a == nil {
			if b != nil {
				return b!
			} else if a != nil {
				return a!
			} else {
				return 0
			}
		}

		if a! < b! {
			let c = a
			a = b
			b = c
		}

		var rest: Int
		while true {
			rest = a! % b!

			if rest == 0 {
				return b!
			} else {
				a = b
				b = rest
			}
		}
	}

	class func gcdForArray(_ array: Array<Int>) -> Int {
		if array.isEmpty {
			return 1
		}

		var gcd = array[0]

		for val in array {
			gcd = UIImage.gcdForPair(val, gcd)
		}

		return gcd
	}

	class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
		let count = CGImageSourceGetCount(source)
		var images = [CGImage]()
		var delays = [Int]()

		for i in 0..<count {
			if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
				images.append(image)
			}

			let delaySeconds = UIImage.delayForImageAtIndex(Int(i),
																											source: source)
			delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
		}

		let duration: Int = {
			var sum = 0

			for val: Int in delays {
				sum += val
			}

			return sum
		}()

		let gcd = gcdForArray(delays)
		var frames = [UIImage]()

		var frame: UIImage
		var frameCount: Int
		for i in 0..<count {
			frame = UIImage(cgImage: images[Int(i)])
			frameCount = Int(delays[Int(i)] / gcd)

			for _ in 0..<frameCount {
				frames.append(frame)
			}
		}

		let animation = UIImage.animatedImage(with: frames,
																					duration: Double(duration) / 1000.0)
		return animation
	}
}



