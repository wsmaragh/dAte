//  ConversationCell.swift
//  Food+Love
//  Created by Winston Maragh on 3/21/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation
import FirebaseAuth


class ChatCell: UICollectionViewCell {

	// MARK: Object properties
	@IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
	@IBOutlet weak var playButton: UIButton!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var bubbleView: UIView!
	@IBOutlet weak var profileImageView: UIImageView!
	@IBOutlet weak var messageImageView: UIImageView!




	//Actions for buttons
	//playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
	//messageImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(zoom)))



	// MARK: Properties
	var chatVC: ChatVC?
	var message: Message?
	var bubbleWidthAnchor: NSLayoutConstraint?
	var bubbleViewRightAnchor: NSLayoutConstraint?
	var bubbleViewLeftAnchor: NSLayoutConstraint?


	// Zoom
	@objc func zoom(tapGesture: UITapGestureRecognizer) {
		if message?.videoUrl != nil { return}
		if let imgVIew = tapGesture.view as? UIImageView {
			self.chatVC?.zoomInForStartingImageView(startingImageView: imgVIew)
		}
	}

	// Play video
	@objc func playVideo() {
		if let videoUrlString = message?.videoUrl , let url = URL.init(string: videoUrlString)  {
			let player = AVPlayer.init(url: url)
			let playerLayer = AVPlayerLayer.init(layer: player)
			playerLayer.frame = bubbleView.bounds
			bubbleView.layer.addSublayer(playerLayer)
			player.play()
			activityIndicatorView.startAnimating()
			playButton.isHidden = true
		}
	}

	// Prepare for Reuse
//	override func prepareForReuse() {
//		super.prepareForReuse()
//		playerLayer?.removeFromSuperlayer()
//		player?.pause()
//		activityIndicatorView.stopAnimating()
//	}
	// Height for Text
	fileprivate func estimatedHeightBasedOnText(text: String) -> CGRect{
		let size = CGSize.init(width: 200, height: 1000)
		let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
		return NSString.init(string: text).boundingRect(with: size, options: option, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
	}
	

	func configureCell(message: Message){
		self.message = message
		playButton.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
		messageImageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(zoom)))
		textView.text = message.text
		if let text = message.text {
			bubbleWidthAnchor?.constant = estimatedHeightBasedOnText(text: text).width + 32
			textView.isHidden = false
		} else if message.imageUrl != nil {
			bubbleWidthAnchor?.constant = 200
			textView.isHidden = true
		}
		playButton.isHidden = message.videoUrl == nil

//		let loverId = usermessage.fromId
//		if let profileImageStr = self.lover?.profileImageUrl {
//			profileImageView.loadImageUsingCacheWithUrlString(profileImageStr)
//		}
		if message.fromId == Auth.auth().currentUser?.uid {
			bubbleView.backgroundColor = UIColor.init(r: 0, g: 137, b: 249)
			textView.textColor = UIColor.white
			profileImageView.isHidden = true
			bubbleViewRightAnchor?.isActive = true
			bubbleViewLeftAnchor?.isActive = false
		} else {
			bubbleView.backgroundColor = UIColor.init(r: 240, g: 240, b: 240)
			textView.textColor = UIColor.black
			profileImageView.isHidden = false
			bubbleViewRightAnchor?.isActive = false
			bubbleViewLeftAnchor?.isActive = true
		}
		if let messageImageUrl = message.imageUrl {
			messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
			messageImageView.isHidden = false
			bubbleView.backgroundColor = UIColor.clear
		}else {
			messageImageView.isHidden = true
		}
	}
}





