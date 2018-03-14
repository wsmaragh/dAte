//  WelcomeVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation


class WelcomeVC: UIViewController {

	// MARK:
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var signupButton: UIButton!

	@IBOutlet weak var imageView: UIImageView!

	// MARK: Propertues
	var player: AVPlayer?


	// MARK:
	@IBAction func loginPressed() {
		let loginVC = LoginVC()
		self.navigationController?.pushViewController(loginVC, animated: true)
	}
	@IBAction func signupPressed() {
		let signupVC = SignupVC()
		self.navigationController?.pushViewController(signupVC, animated: true)
	}


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		initializeVideoPlayerWithVideo()
	}


	// MARK: Helper functions
	func initializeVideoPlayerWithVideo() {
		let videoString:String? = Bundle.main.path(forResource: "coffeecouple", ofType: "mp4")
		guard let unwrappedVideoPath = videoString else {return}
		let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
		self.player = AVPlayer(url: videoUrl)
		let videoLayer: AVPlayerLayer = AVPlayerLayer(player: player)
		videoLayer.frame = view.bounds
		videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		view.layer.addSublayer(videoLayer)
	}



//    // MARK: - Navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }


}
