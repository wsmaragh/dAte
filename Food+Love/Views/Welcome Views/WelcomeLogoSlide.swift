
//  WelcomeLogoSlide.swift
//  Food+Love
//  Created by Winston Maragh on 3/20/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit


class WelcomeLogoSlide: UIView {

	lazy var picture: UIImageView = {
		let iv = UIImageView()
		iv.image = #imageLiteral(resourceName: "Logo3")
		return iv
	}()

//	lazy var title: UILabel = {
//		let label = UILabel()
//		label.text = "dAte"
//		label.textColor = .white
//		label.textAlignment = .center
//		label.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
//		return label
//	}()

	lazy var details: UITextView = {
		let tv = UITextView()
		tv.text = "Create meaningful connections through food."
		tv.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
		tv.textColor = UIColor.white
		tv.textAlignment = .center
		tv.backgroundColor = .clear
		return tv
	}()

	// MARK: Setup
	override init(frame: CGRect) {
		super.init(frame: UIScreen.main.bounds)
		setupViewConstraints()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
	}

	fileprivate func setupViewConstraints() {
		// Picture
		addSubview(picture)
		picture.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			picture.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
			picture.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.25),
			picture.centerXAnchor.constraint(equalTo: centerXAnchor),
			picture.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -70)
			])
		// Title
//		addSubview(title)
//		title.translatesAutoresizingMaskIntoConstraints = false
//		NSLayoutConstraint.activate([
//			title.bottomAnchor.constraint(equalTo: picture.topAnchor, constant: 10),
//			title.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
//			title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
//			title.centerXAnchor.constraint(equalTo: centerXAnchor)
//			])
		// Details
		addSubview(details)
		details.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			details.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 10),
			details.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
			details.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
			details.centerXAnchor.constraint(equalTo: centerXAnchor)
			])
	}
}
