
//  FillOutProfileVC.swift
//  Food+Love
//  Created by C4Q on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Firebase


class SetupProfileVC: UIViewController, UIScrollViewDelegate {

	// MARK: Outlets/Properties
	@IBOutlet weak var profileScrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!
	

	// MARK: Properties
	let preferenceSlide = PreferenceProfile()
	let aboutSlide = AboutProfile()
	let habitsSlide = HabitsProfile()
	let videoSlide = VideoProfile()
//	private var profileSlides = [UIView]()
	private var profileSlides: [UIView] = []
//	private var profileSlides: [UIView] = {
//		let preferenceSlide = PreferenceProfile()
//		let aboutSlide = AboutProfile()
//		let habitsSlide = HabitsProfile()
//		let videoSlide = VideoProfile()
//		return [preferenceSlide, aboutSlide, habitsSlide, videoSlide]
//	}()
	var currentUser: User?

	
	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.title = "Setup Profile"
		currentUser = Auth.auth().currentUser
		profileSlides = [preferenceSlide, aboutSlide, habitsSlide, videoSlide]
		profileScrollView.delegate = self
//		profileSlides = createSlides()
		addSlidesToScrollView(slides: profileSlides)
//		setupPageControl()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}



	// MARK: Helper Methods
	@IBAction func completeProfile(_ sender: UIButton) {
		let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
		if let window = UIApplication.shared.delegate?.window {
			window?.rootViewController = mainVC
		}
	}

	func createSlides() -> [UIView] {
		let preferenceSlide = PreferenceProfile()
		let aboutSlide = AboutProfile()
		let habitsSlide = HabitsProfile()
		let videoSlide = VideoProfile()
		return [preferenceSlide, aboutSlide, habitsSlide, videoSlide]
	}

//	func createSlides() -> [UIView] {
//		let slide1 = WelcomeLogoSlide()
//		let slide2 = WelcomeSlide(title: "Bond over food", details: "Start with a simple meal and build from there. Food has played an integral part in shaping culture and communication", picture: #imageLiteral(resourceName: "bg_coffee"))
//		let slide3 = WelcomeSlide(title: "Companionship", details: "Why eat alone, when you can also meet your soulmate", picture: #imageLiteral(resourceName: "bg_plandate"))
//		let slide4 = WelcomeSlide(title: "Plan date in app", details: "Spend quality time exploring each other...", picture: #imageLiteral(resourceName: "bg_love1"))
//		return [slide1, slide2, slide3, slide4]
//	}

	func setupPageControl(){
		if !profileSlides.isEmpty {
			pageControl.numberOfPages = profileSlides.count
			pageControl.currentPage = 0
			pageControl.currentPageIndicatorTintColor = UIColor.red
			pageControl.pageIndicatorTintColor = UIColor.white
			view.bringSubview(toFront: pageControl)
		}
	}

	func addSlidesToScrollView(slides: [UIView]) {
		profileScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: profileScrollView.bounds.height)
		profileScrollView.isPagingEnabled = true
		profileScrollView.isDirectionalLockEnabled = true
		for i in 0..<profileSlides.count {
			profileSlides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
			profileScrollView.addSubview(profileSlides[i])
		}
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
		pageControl.currentPage = Int(currentPage)
	}
	
	//let flowersGif = UIImage.gifImageWithName("flowers")
	//let slide2 = Slide(title: "Bond over food", details: "Food plays an vital part in fostering conversations", picture: flowersGif!)

}
