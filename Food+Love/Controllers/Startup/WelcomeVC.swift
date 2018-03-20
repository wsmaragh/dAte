//  WelcomeVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/17/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVKit


class WelcomeVC: UIViewController, UIScrollViewDelegate {

	// MARK: Outlets/Properties
	@IBOutlet weak var welcomeSlideScrollView: UIScrollView!
	@IBOutlet weak var welcomePageControl: UIPageControl!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var signupButton: UIButton!

	// MARK: Properties
	private var welcomeSlides = [UIView]()

	// MARK: Action Buttons
	@IBAction func loginPressed() {
//		let loginVC = LoginVC.storyboardInstance()
//		self.navigationController?.pushViewController(loginVC, animated: true)
	}

	@IBAction func signupPressed() {
//		let signupVC = SignupVC()
//		self.navigationController?.pushViewController(signupVC, animated: true)
	}

	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		welcomeSlideScrollView.delegate = self
		welcomeSlides = createSlides()
		addSlidesToScrollView(slides: welcomeSlides)
		setupPageControl()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		setupAndPlayVideoBackground()
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		self.navigationController?.isNavigationBarHidden = false
	}


	// MARK: Helper Methods

	///Slides
	func createSlides() -> [UIView] {

		//let flowersGif = UIImage.gifImageWithName("flowers")
		//let slide2 = Slide(title: "Bond over food", details: "Food plays an vital part in fostering conversations", picture: flowersGif!)

		let slide1 = WelcomeLogoSlide()
		let slide2 = WelcomeSlide(title: "Bond over food", details: "Start with a simple meal...", picture: #imageLiteral(resourceName: "bg_coffee"))
		let slide3 = WelcomeSlide(title: "Companionship", details: "Why eat alone, when you can also meet your soulmate.", picture: #imageLiteral(resourceName: "bg_plandate"))
		let slide4 = WelcomeSlide(title: "Real Connections", details: "Spend quality time exploring...", picture: #imageLiteral(resourceName: "holdinghands"))

		let slide5 = WelcomeSlide(title: "Start Simple, go deeper", details: "The beautiful first slide is amazing", picture: #imageLiteral(resourceName: "bg_love1"))

		let slide6 = WelcomeSlide(title: "Take it to the next level", details: "Wow you may be even more stunning than the previous", picture: #imageLiteral(resourceName: "bg_date2"))
		return [slide1, slide2, slide3, slide4, slide5, slide6]
	}

	func setupPageControl(){
		welcomePageControl.numberOfPages = welcomeSlides.count
		welcomePageControl.currentPage = 0
		welcomePageControl.currentPageIndicatorTintColor = UIColor.white
		welcomePageControl.pageIndicatorTintColor = UIColor.red
		view.bringSubview(toFront: welcomePageControl)
	}

	func addSlidesToScrollView(slides: [UIView]) {
		welcomeSlideScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: welcomeSlideScrollView.bounds.height)
		welcomeSlideScrollView.isPagingEnabled = true
		welcomeSlideScrollView.isDirectionalLockEnabled = true
		for i in 0..<slides.count {
			slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
			welcomeSlideScrollView.addSubview(slides[i])
		}
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
		welcomePageControl.currentPage = Int(currentPage)
	}

	//////////////////////////////////
	// MARK: Background Video Player
	func setupAndPlayVideoBackground() {
		//video URL
		guard let videoURL = Bundle.main.url(forResource: "couple", withExtension: "mp4") else {return}

		//Shade
		let shade = UIView(frame: self.view.frame)
		shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
		view.addSubview(shade)
		view.sendSubview(toBack: shade)

		//AV Player
		var avPlayer = AVPlayer()
		avPlayer = AVPlayer(url: videoURL)
		let avPlayerLayer = AVPlayerLayer(player: avPlayer)
		avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		avPlayer.volume = 0
		avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
		avPlayerLayer.frame = view.layer.bounds

		//UIView Layer for Video
		let layer = UIView(frame: self.view.frame)
		view.backgroundColor = UIColor.clear
		view.layer.insertSublayer(avPlayerLayer, at: 0)
		view.addSubview(layer)
		view.sendSubview(toBack: layer)

		//Notification
		NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)

		//Play video
		avPlayer.play()
	}

	@objc func playerDidFinishedPlaying(notification: NSNotification) {
		if let player = notification.object as? AVPlayerItem {
			player.seek(to: kCMTimeZero, completionHandler: nil)
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return UIStatusBarStyle.lightContent
		//return UIStatusBarStyle.default
	}

}
