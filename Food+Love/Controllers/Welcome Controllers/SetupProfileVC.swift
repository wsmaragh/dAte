
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


	//Scenedock Views
	@IBOutlet var preferenceSlide: PreferenceProfile!
	@IBOutlet var aboutSlide: AboutProfile!
	@IBOutlet var signupSlide: UIView!
	@IBOutlet var videoSlide: UIView!


	//Properties Fields
	@IBOutlet weak var favoriteFoodCategory1TF: UITextField!
	@IBOutlet weak var favoriteFoodCategory2TF: UITextField!
	@IBOutlet weak var favoriteFoodCategory3TF: UITextField!
	@IBOutlet weak var favoriteRestaurant: UITextField!
	@IBOutlet weak var genderSC: UISegmentedControl!
	@IBOutlet weak var genderPreferenceSC: UISegmentedControl!
	@IBOutlet weak var dobPicker: UIDatePicker!
	@IBOutlet weak var zipcodeTF: UITextField!


	// MARK: Properties
	var currentUser: User?
	private var profileSlides = [UIView]()
	private var slideIndex = 0


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		currentUser = Auth.auth().currentUser
		profileScrollView.delegate = self
		profileSlides = [preferenceSlide, aboutSlide, signupSlide]
		addSlidesToScrollView(slides: profileSlides)
		setupPageControl()
		navigationController?.title = "Setup Profile"
	}


	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		self.navigationController?.setNavigationBarHidden(true, animated: animated)
	}


	// MARK: Helper Methods
	func addSlidesToScrollView(slides: [UIView]) {
		profileScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: profileScrollView.bounds.height)
		profileScrollView.isPagingEnabled = true
		profileScrollView.isDirectionalLockEnabled = true
		for i in 0..<slides.count {
			slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: profileScrollView.frame.height)
			profileScrollView.addSubview(slides[i])
		}
	}

	func setupPageControl(){
		scrollViewDidScroll(profileScrollView)

	}



	// MARK: Action
	@IBAction func addVideoButton(_ sender: UIButton) {


	}


//	@IBAction func signup(_ sender: UIButtonX) {
//		guard let name = self.firstNameTF.text, name != "" else {
//			showAlert(title: "Please enter a name", message: ""); return
//		}
//		guard let email = self.emailTF.text, email != "" else {
//			showAlert(title: "Please enter an email", message: ""); return
//		}
//		guard let password = self.passwordTF.text, password != "" else {
//			showAlert(title: "Please enter a valid password", message: ""); return
//		}
//		if profileImageButton.image(for: UIControlState.normal) == #imageLiteral(resourceName: "selfieCamera") {
//			showAlert(title: "Please add a profile image", message: ""); return
//		}
//		guard let image = self.profileImageButton.image(for: .normal) else {return}
//		if email.contains(" ") {
//			showAlert(title: "No spaces allowed in email!", message: nil); return
//		}
//		if password.contains(" ") {
//			showAlert(title: "No spaces allowed in password!", message: nil); return
//		}
//
//		AuthUserService.manager.createUser(name: name, email: email, password: password, profileImage: image)
//	}

//	@IBAction func nextPage(_ sender: UIButton) {
//			let scroll : UIScrollView? = profileScrollView(self.view)
//			let scrollPoint = CGPointMake(0.0, 0.0)
//			println("Button Tapped")
//CGPoint(x: <#T##CGFloat#>, y: profileScrollView.)
//		profileScrollView.setContentOffset(, animated: <#T##Bool#>)
//			if scroll {
//				scroll!.setContentOffset(scrollPoint, animated: true)
//			}
//
////		profileScrollView.contentOffset.x + profileScrollView.bounds.width
////		let currentPage = profileScrollView.contentOffset.x / profileScrollView.frame.size.width
////		pageControl.currentPage = Int(currentPage)
////		slideIndex = pageControl.currentPage
//	}
//
//	setContentOffset:animated:

	@IBAction func completeProfile(_ sender: UIButton) {
		//add user details to database
		guard let favCat1 = favoriteFoodCategory1TF.text else {return}
		guard let favCat2 = favoriteFoodCategory2TF.text else {return}
		guard let favCat3 = favoriteFoodCategory3TF.text else {return}
		guard let favRest = favoriteRestaurant.text else {return}
		guard let zipcode = 	zipcodeTF.text else {return}
		let gender = genderSC.selectedSegmentIndex == 0 ? "Male" : "Female"
		let genderPreference =  genderPreferenceSC.selectedSegmentIndex == 0 ? "Male" : "Female"
		let dobDate = dobPicker.date
		let dob = DBService.manager.formatDateforDOB(with: dobDate)
		let bio = ""

		DBService.manager.addLoverDetails(favCat1: favCat1, favCat2: favCat2, favCat3: favCat3, favRestaurant: favRest, zipcode: zipcode, gender: gender, genderPreference: genderPreference, dateOfBirth: dob, bio: bio)

		//transition to mainVC
//		let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
//		if let window = UIApplication.shared.delegate?.window {
//			window?.rootViewController = mainVC
//		}
		print("user details added")
	}
	

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
		pageControl.currentPage = Int(currentPage)
		slideIndex = pageControl.currentPage
	}
	

}
