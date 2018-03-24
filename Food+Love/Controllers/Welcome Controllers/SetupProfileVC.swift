
//  FillOutProfileVC.swift
//  Food+Love
//  Created by C4Q on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit


class SetupProfileVC: UIViewController, UIScrollViewDelegate {

	// MARK: Outlets/Properties
	@IBOutlet weak var setupProfileScrollView: UIScrollView!
	@IBOutlet weak var pageControl: UIPageControl!


	// MARK: Properties
	private var profileSlides = [UIView]() {
		didSet {
			addSlidesToScrollView(slides: profileSlides)
		}
	}

	
	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .red
		navigationController?.title = "Setup Profile"
		setupProfileScrollView.delegate = self
		profileSlides = createSlides()
		setupPageControl()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}


	// MARK: Helper Methods
	func createSlides() -> [UIView] {
		//TODO: setup actual Views for each
		let foodPreferenceSlide = UIView() //3 food categories, 1 favorite dish, favorite restaurant
		let backgroundSlide = UIView()  //gender, age, kids, gender preference
		let habitsSlide = UIView()  //drink, smoke, drugs
		let locationSlide = UIView()
		let photosSlide = UIView()
		let shortVideo = UIView()
		return [foodPreferenceSlide, backgroundSlide, habitsSlide, locationSlide, photosSlide, shortVideo]
	}

	func setupPageControl(){
		pageControl.numberOfPages = profileSlides.count
		pageControl.currentPage = 0
		pageControl.currentPageIndicatorTintColor = UIColor.red
		pageControl.pageIndicatorTintColor = UIColor.white
		view.bringSubview(toFront: pageControl)
	}

	func addSlidesToScrollView(slides: [UIView]) {
		setupProfileScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: setupProfileScrollView.bounds.height)
		setupProfileScrollView.isPagingEnabled = true
		setupProfileScrollView.isDirectionalLockEnabled = true
		for i in 0..<profileSlides.count {
			profileSlides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
			setupProfileScrollView.addSubview(profileSlides[i])
		}
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
		pageControl.currentPage = Int(currentPage)
	}
	
	//let flowersGif = UIImage.gifImageWithName("flowers")
	//let slide2 = Slide(title: "Bond over food", details: "Food plays an vital part in fostering conversations", picture: flowersGif!)

}
