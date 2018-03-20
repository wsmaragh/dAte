//  LoverCell.swift
//  Food+Love
//  Created by Winston Maragh on 3/17/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Firebase


class LoverCell: UITableViewCell {

	// MARK: Objects
	let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 24
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	let timeLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 13)
		label.textColor = UIColor.darkGray
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()


	// MARK: Properties
	var message: Message? {
		didSet {
			setupNameAndProfileImage()
			detailTextLabel?.text = message?.text
			if let seconds = message?.timestamp?.doubleValue {
				let timestampDate = Date(timeIntervalSince1970: seconds)
				let dateFormatter = DateFormatter()
				dateFormatter.dateFormat = "hh:mm:ss a"
				timeLabel.text = dateFormatter.string(from: timestampDate)
			}
		}
	}


	// MARK: Setup Name And Profile
	fileprivate func setupNameAndProfileImage() {
		if let id = message?.chatPartnerId() {
			let ref = Database.database().reference().child("users").child(id)
			ref.observeSingleEvent(of: .value, with: { (snapshot) in
				if let dictionary = snapshot.value as? [String: AnyObject] {
					self.textLabel?.text = dictionary["name"] as? String
					if let profileImageUrl = dictionary["profileImageUrl"] as? String {
						self.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
					}
				}
			}, withCancel: nil)
		}
	}


	// MARK: Setup
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
		setupConstraints()
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
		detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
	}


	// MARK: Constraints
	private func setupConstraints(){
		addSubview(profileImageView)
		profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
		profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
		profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
		profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
		addSubview(timeLabel)
		timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 18).isActive = true
		timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
		timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
	}

}

