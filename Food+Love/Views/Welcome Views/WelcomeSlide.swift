
//  WelcomeSlide.swift
//  Food+Love
//  Created by Winston Maragh on 3/17/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit


class WelcomeSlide: UIView {

	lazy var title: UILabel = {
		let label = UILabel()
		label.text = "Title"
		label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
		label.textColor = UIColor.white
		label.textAlignment = .center
		label.numberOfLines = 0
		return label
	}()

	lazy var details: UITextView = {
		let tv = UITextView()
		tv.text = "These are the details of the view."
		tv.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
		tv.textColor = UIColor.white
		tv.textAlignment = .center
		tv.backgroundColor = .clear
		return tv
	}()

	lazy var picture: UIImageViewX = {
		let iv = UIImageViewX()
		iv.cornerRadius = 16
		iv.clipsToBounds = true
		iv.image = #imageLiteral(resourceName: "bg_coffee")
		return iv
	}()


	// MARK: Setup
	override init(frame: CGRect) {
		super.init(frame: UIScreen.main.bounds)
		setupViewConstraints()
	}
	convenience init(title: String, details: String, picture: UIImage) {
		self.init()
		self.title.text = title
		self.details.text = details
		self.picture.image = picture
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
			picture.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
			picture.heightAnchor.constraint(equalTo: safeAreaLayoutGuide.heightAnchor, multiplier: 0.30),
			picture.centerXAnchor.constraint(equalTo: centerXAnchor),
			picture.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -60)
		])
		// Title
		addSubview(title)
		title.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			title.bottomAnchor.constraint(equalTo: picture.topAnchor, constant: -20),
			title.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.6),
			title.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
		//Details Label
		addSubview(details)
		details.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			details.topAnchor.constraint(equalTo: picture.bottomAnchor, constant: 20),
			details.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
			details.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
			details.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
}

