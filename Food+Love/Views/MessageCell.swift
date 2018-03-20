//  MessageCell.swift
//  Food+Love
//  Created by Winston Maragh on 3/17/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation

class MessageCell: UICollectionViewCell {

	// MARK: Objects
	let activityIndicatorView: UIActivityIndicatorView = {
		let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
		aiv.translatesAutoresizingMaskIntoConstraints = false
		aiv.hidesWhenStopped = true
		return aiv
	}()
	lazy var playButton: UIButton = {
		let button = UIButton(type: .system)
		button.translatesAutoresizingMaskIntoConstraints = false
		let image = UIImage(named: "play")
		button.tintColor = UIColor.white
		button.setImage(image, for: UIControlState())
		button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
		return button
	}()
	let textView: UITextView = {
		let tv = UITextView()
		tv.text = "This is a message"
		tv.font = UIFont.systemFont(ofSize: 16)
		tv.translatesAutoresizingMaskIntoConstraints = false
		tv.backgroundColor = UIColor.clear
		tv.textColor = .white
		tv.isEditable = false
		return tv
	}()
	let bubbleView: UIView = {
		let view = UIView()
		view.backgroundColor = blueColor
		view.translatesAutoresizingMaskIntoConstraints = false
		view.layer.cornerRadius = 16
		view.layer.masksToBounds = true
		return view
	}()
	let profileImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 16
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	lazy var messageImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.layer.cornerRadius = 16
		imageView.layer.masksToBounds = true
		imageView.contentMode = .scaleAspectFill
		imageView.isUserInteractionEnabled = true
		imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
		return imageView
	}()


	// MARK: Properties
	static let blueColor = UIColor(r: 0, g: 137, b: 249)
	var message: Message?
	var chatLogController: ConversationVC?
	var playerLayer: AVPlayerLayer?
	var player: AVPlayer?
	var bubbleWidthAnchor: NSLayoutConstraint?
	var bubbleViewRightAnchor: NSLayoutConstraint?
	var bubbleViewLeftAnchor: NSLayoutConstraint?


	// MARK: Helper Methods
	// PLAY
	@objc func handlePlay() {
		if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString) {
			player = AVPlayer(url: url)
			playerLayer = AVPlayerLayer(player: player)
			playerLayer?.frame = bubbleView.bounds
			bubbleView.layer.addSublayer(playerLayer!)
			player?.play()
			activityIndicatorView.startAnimating()
			playButton.isHidden = true
			print("Attempting to play video......???")
		}
	}
	// ZOOM
	@objc func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
		if message?.videoUrl != nil { return}
		if let imageView = tapGesture.view as? UIImageView {
			self.chatLogController?.performZoomInForStartingImageView(imageView)
		}
	}

	// PREPARE FOR RESUSE
	override func prepareForReuse() {
		super.prepareForReuse()
		playerLayer?.removeFromSuperlayer()
		player?.pause()
		activityIndicatorView.stopAnimating()
	}


	// MARK: Setup
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupConstraints(){
		// BUBBLEVIEW
		addSubview(bubbleView)
		bubbleView.addSubview(messageImageView)
		messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
		messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
		messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
		messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true

		// PLAY BUTTON
		bubbleView.addSubview(playButton)
		playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
		playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
		playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
		playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

		// ACTIVITY INDICATOR
		bubbleView.addSubview(activityIndicatorView)
		activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
		activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
		activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true

		// PROFILE IMAGEVIEW
		addSubview(profileImageView)
		profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
		profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
		profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true

		// BUBBLEVIEW LEFT & RIGHT
		bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
		bubbleViewRightAnchor?.isActive = true
		bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
		//        bubbleViewLeftAnchor?.active = false
		bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
		bubbleWidthAnchor?.isActive = true
		bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

		// TEXTVIEW
		addSubview(textView)
		//        textView.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
		textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
		textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
		//        textView.widthAnchor.constraintEqualToConstant(200).active = true
		textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
	}

}

