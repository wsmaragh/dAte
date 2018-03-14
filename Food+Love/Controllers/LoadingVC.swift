//  LoadingVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation
import CoreMedia


class LoadingVC: UIViewController {

	// MARK: Object Properties
	@IBOutlet var videoView: UIView!

	// MARK: Properties
	private var videoPlayer: AVPlayer?

	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		videoView.contentMode = .scaleAspectFill

		NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if videoPlayer == nil {
			setupAndPlayVideo()
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		videoPlayer?.play()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		videoPlayer?.pause()
	}


	// MARK: Helper
	@objc func appDidBecomeActive() {
		videoPlayer?.play()
	}

	private func setupAndPlayVideo() {
		let path = Bundle.main.path(forResource: "coffeecouple", ofType: "mp4")
//		let url  = URL.fileURL(withPath: path!)
		let url  = URL(fileURLWithPath: path!)

		videoPlayer = AVPlayer(url: url)
		if let videoPlayer = videoPlayer {
			videoPlayer.allowsExternalPlayback = false
			let videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
			videoPlayerLayer.videoGravity = .resizeAspectFill
			videoView.layer.addSublayer(videoPlayerLayer)
			videoPlayerLayer.frame = videoView.bounds
			videoPlayer.rate = 2
			NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoPlayer.currentItem)
		}
	}

	@objc func playerDidFinishPlaying(notification: NSNotification) {
		if let playerItem = notification.object as? AVPlayerItem {
			playerItem.seek(to: kCMTimeZero, completionHandler: nil)
		}
		//Loop video
		if let videoPlayer = videoPlayer {
			videoPlayer.play()
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
//		return UIStatusBarStyle.lightContent
		return UIStatusBarStyle.default
	}

}
