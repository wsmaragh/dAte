//
//  DiscoverVC.swift
//  Food+Love
//  Created by Gloria Washington on 3/21/18.
//  Copyright © 2018 Gloria Washington. All rights reserved.
//

import UIKit
import Firebase
import VegaScrollFlowLayout


class DiscoverVC: UIViewController {


	// Outlets
	@IBOutlet weak var discoverCV: UICollectionView!
	@IBOutlet var foodTagCV: UICollectionView!

	//Properties
	let cellSpacing: CGFloat = 0.6
	//Dummy Data
	var lover1 = Lover(id: "0001", name: "Susan", email: "susan@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/foodnlove-84523.appspot.com/o/images%2FSAh0Op05UXWT9nUybEfDw3bzmlc2?alt=media&token=64b165c5-b299-4194-967a-93a498a26f86", profileVideoUrl: nil, dateOfBirth: nil, zipcode: nil, city: nil, bio: nil, gender: "Male", genderPreference: "Female", smoke: "Yes", drink: "Yes", drugs: "No", favRestaurants: nil, likedUsers: nil, usersThatLikeYou: nil)
	var lovers = [Lover](){
		didSet{
			discoverCV.reloadData()
		}
	}
	var foodTags = [String]() {
		didSet {
			foodTagCV.reloadData()
		}
	}


	// view lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		if Auth.auth().currentUser == nil {
			let welcomeVC = UIViewController.storyboardInstance(storyboardName: "Main", viewControllerIdentifiier: "WelcomeController")
			if let window = UIApplication.shared.delegate?.window {
				window?.rootViewController = welcomeVC
			}
		}
		loadLovers()
		loadFoodTags()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpDiscoverCV()
		setUpBackground()
		setUpTagCV()
	}


	private func setUpDiscoverCV() {
		discoverCV.dataSource = self
		discoverCV.delegate = self
		foodTagCV.dataSource = self
		foodTagCV.delegate = self

		let screenSize = UIScreen.main.bounds.size
		let cellWidth = floor(screenSize.width * cellSpacing)
		let cellHeight = floor(screenSize.height * cellSpacing)

		let insetX = (view.bounds.width  - cellWidth) / 3
		let insetY = (view.bounds.height - cellHeight) / 3

		let layout = VegaScrollFlowLayout()
		discoverCV.collectionViewLayout = layout
		layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
		discoverCV?.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)
	}

	private func setUpTagCV() {
		foodTagCV.layer.cornerRadius = 45
		foodTagCV.layer.borderColor = UIColor.black.cgColor
		foodTagCV.layer.borderWidth = 0.5
	}

	private func setUpBackground() {
		let backgroundImage = UIImageView()
		backgroundImage.image = #imageLiteral(resourceName: "bg_desert")
		backgroundImage.contentMode = .scaleToFill
		view.addSubview(backgroundImage)

		let blur = UIBlurEffect(style: .regular)
		let blurView = UIVisualEffectView(effect: blur)
		blurView.frame = backgroundImage.frame
		blurView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImage.addSubview(blurView)
	}

	private func loadLovers() {
		getAllLoversExceptCurrent()
	}

	private func loadFoodTags(){
		foodTags = ["Thai", "Japanese", "Tacos"]
	}

	func getAllLoversExceptCurrent() {
		Database.database().reference().child("lovers").observe(.childAdded, with: { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject]{
				let lover = Lover(dictionary: dict)
				lover.id = snapshot.key
				if lover.id != Auth.auth().currentUser?.uid {
					self.lovers.append(lover)
				}
			}
		}, withCancel: nil)
	}
}


//MARK - UICollectionView Datasource
extension DiscoverVC: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if collectionView == foodTagCV { return foodTags.isEmpty ? 1 : foodTags.count }
		return lovers.isEmpty ? 0 : lovers.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if collectionView == foodTagCV {
			let cell = foodTagCV.dequeueReusableCell(withReuseIdentifier: "FoodTagCell", for: indexPath) as! FoodTagCollectionViewCell
			let tag = foodTags[indexPath.row]
			cell.foodTagLabel.text = tag
			return cell
		}

		let cell = discoverCV.dequeueReusableCell(withReuseIdentifier: "DiscoverCell", for: indexPath) as! DiscoverCollectionViewCell
//		if lovers.isEmpty {return UICollectionViewCell()}
		let lover = lovers[indexPath.row]
		cell.userNameAgeLabel.text = lover.name
		if let image = lover.profileImageUrl {
			cell.userPictureImageView.loadImageUsingCacheWithUrlString(image)
		} else {
			cell.userPictureImageView.image = #imageLiteral(resourceName: "user2")
		}
		return cell
	}
}


//MARK - UICollectionView Delegate
extension DiscoverVC: UICollectionViewDelegate {

}


//MARK - UICollectionView Flow Layout
extension DiscoverVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		if collectionView == foodTagCV {
			//perform filter of discover CV here
		}
		let selectedLover = lovers[indexPath.row]
		let storyboard = UIStoryboard(name: "Profile", bundle: nil)
		let profileVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
		profileVC.lover = selectedLover
		self.navigationController?.pushViewController(profileVC, animated: true)
	}
}
