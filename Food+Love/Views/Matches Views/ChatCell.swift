
//  ConversationCell.swift
//  Food+Love
//  Created by Winston Maragh on 3/21/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation
import FirebaseAuth



class PartnerChatCell: UICollectionViewCell {
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var bubbleView: UIView!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var messageImageView: UIImageView!
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
	@IBOutlet weak var playButton: UIButton!

	//Properties
	var chatVC: ChatVC?
	var message: Message?
	var player: AVPlayer?
	var playerLayer: AVPlayerLayer?

	// Play video
	@objc func playVideo() {
		if let videoUrlString = message?.videoUrl , let url = URL.init(string: videoUrlString)  {
			//			let player = AVPlayer.init(url: url)
			player = AVPlayer.init(url: url)
			//			let playerLayer = AVPlayerLayer.init(layer: player)
			playerLayer = AVPlayerLayer.init(layer: player)
			playerLayer?.frame = bubbleView.bounds
			bubbleView.layer.addSublayer(playerLayer!)
			player?.play()
			activityIndicatorView.startAnimating()
			playButton.isHidden = true
		}
	}

	// Prepare for Reuse
	override func prepareForReuse() {
		super.prepareForReuse()
		playerLayer?.removeFromSuperlayer()
		player?.pause()
		activityIndicatorView.stopAnimating()
	}

	// Zoom
	@objc func zoom(tapGesture: UITapGestureRecognizer) {
		if message?.videoUrl != nil { return}
		if let imgVIew = tapGesture.view as? UIImageView {
//						self.chatVC?.zoomInForStartingImageView(startingImageView: imgVIew)
		}
	}

	func configureCell(message: Message){
		self.message = message
		//text message
		if let text = message.text {
			textView.isHidden = false
			messageImageView.isHidden = true
			activityIndicatorView.isHidden = true
			textView.text = text
		}
		//photo message
		else if let imageStr = message.imageUrl {
			textView.isHidden = true
			messageImageView.isHidden = false
			messageImageView.loadImageUsingCacheWithUrlString(imageStr)
			activityIndicatorView.isHidden = true
		}
		//video message
		else if let videoStr = message.videoUrl {
			textView.isHidden = true
			messageImageView.isHidden = false
			activityIndicatorView.isHidden = true
		}
			//location message
		else if let locationStr = message.location {
			textView.isHidden = true
			messageImageView.isHidden = false
			messageImageView.image = #imageLiteral(resourceName: "locationPerson")
		}
		playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
		messageImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(zoom)))
//		playButton.isHidden = message.videoUrl == nil
	}

}


class UserChatCell: UICollectionViewCell {
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var bubbleView: UIView!
	@IBOutlet weak var messageImageView: UIImageView!

	//Properties
	var chatVC: ChatVC?
	var message: Message?
	var player: AVPlayer?
	var playerLayer: AVPlayerLayer?

	// Play video
	@objc func playVideo() {
		if let videoUrlString = message?.videoUrl , let url = URL.init(string: videoUrlString)  {
			//			let player = AVPlayer.init(url: url)
			player = AVPlayer.init(url: url)
			//			let playerLayer = AVPlayerLayer.init(layer: player)
			playerLayer = AVPlayerLayer.init(layer: player)
			playerLayer?.frame = bubbleView.bounds
			if let playerLayer = playerLayer {
				bubbleView.layer.addSublayer(playerLayer)
			}
			player?.play()
			activityIndicatorView.startAnimating()
			playButton.isHidden = true
		}
	}

	// Prepare for Reuse
	override func prepareForReuse() {
		super.prepareForReuse()
		playerLayer?.removeFromSuperlayer()
		player?.pause()
		activityIndicatorView.stopAnimating()
	}

	// Zoom
	@objc func zoom(tapGesture: UITapGestureRecognizer) {
		if message?.videoUrl != nil { return}
		if let imgVIew = tapGesture.view as? UIImageView {
			//			self.chatVC?.zoomInForStartingImageView(startingImageView: imgVIew)
		}
	}


	//User
	func configureCell(message: Message){
		self.message = message
		//text message
		if let text = message.text {
			textView.isHidden = false
			messageImageView.isHidden = true
			activityIndicatorView.isHidden = true
			textView.text = text
		}
		//photo message
		else if let imageStr = message.imageUrl {
			textView.isHidden = true
			messageImageView.isHidden = false
			messageImageView.loadImageUsingCacheWithUrlString(imageStr)
			activityIndicatorView.isHidden = true
		}
		//video message
		else if let videoStr = message.videoUrl {
			textView.isHidden = true
			messageImageView.isHidden = false
			activityIndicatorView.isHidden = true
		}
		//location message
		else if let locationStr = message.location {
			textView.isHidden = true
			messageImageView.isHidden = false
			messageImageView.image = #imageLiteral(resourceName: "locationPerson")
		}
		playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
		messageImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(zoom)))
		playButton.isHidden = message.videoUrl == nil
	}

}
