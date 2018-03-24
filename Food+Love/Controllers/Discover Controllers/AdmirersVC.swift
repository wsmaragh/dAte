//
//  AdmirersVC.swift
//  Food+Love
//
//  Created by Gloria Washington on 3/23/18.
//  Copyright © 2018 Gloria Washington. All rights reserved.
//


import UIKit
import VegaScrollFlowLayout
import Firebase


class AdmirersVC: UIViewController {

	@IBOutlet weak var admirerCV: UICollectionView!

	var admirers = [Lover](){
		didSet{
			admirerCV.reloadData()
		}
	}

	var lover1 = Lover(id: "0001", name: "Susan", email: "susan@gmail.com", profileImageUrl: "https://firebasestorage.googleapis.com/v0/b/foodnlove-84523.appspot.com/o/images%2FSAh0Op05UXWT9nUybEfDw3bzmlc2?alt=media&token=64b165c5-b299-4194-967a-93a498a26f86", profileVideoUrl: nil, dateOfBirth: nil, zipcode: nil, city: nil, bio: nil, gender: "Male", genderPreference: "Female", smoke: "Yes", drink: "Yes", drugs: "No", favRestaurants: nil, likedUsers: nil, usersThatLikeYou: nil)

	override func viewWillAppear(_ animated: Bool) {
		loadData()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpCollectionViewLayout()

	}

	private func loadData() {
		admirers = [lover1]
		getAllLoversExceptCurrent()
	}

	func getAllLoversExceptCurrent() {
		Database.database().reference().child("lovers").observe(.childAdded, with: { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject]{
				let lover = Lover(dictionary: dict)
				lover.id = snapshot.key
				if lover.id != Auth.auth().currentUser?.uid {
					self.admirers.append(lover)
				}
			}
		}, withCancel: nil)
	}
	func setUpCollectionViewLayout() {
		let layout = VegaScrollFlowLayout()
		admirerCV.dataSource = self
		admirerCV.delegate = self
		admirerCV.collectionViewLayout = layout
		layout.minimumLineSpacing = 20
		layout.itemSize = CGSize(width: admirerCV.frame.width, height: 200)
		layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
		layout.isPagingEnabled = false
		layout.springHardness = 200
		admirerCV.collectionViewLayout.invalidateLayout()
	}

}


extension AdmirersVC: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return admirers.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = admirerCV.dequeueReusableCell(withReuseIdentifier: "AdmirerCell", for: indexPath) as! AdmirerCollectionViewCell
		let admirer = admirers[indexPath.row]
		cell.admirerNameLabel.text = admirer.name
		cell.admirerFoodsLabel.text = "Chinese, Thai, Italian"
		cell.admirerShareLabel.text = "Italian"
		if let image = admirer.profileImageUrl {
			cell.admirerImageView.loadImageUsingCacheWithUrlString(image)
		} else {
			cell.admirerImageView.image = #imageLiteral(resourceName: "user2")
		}
		return cell
	}

}

extension AdmirersVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "Feed", bundle: nil)
		let profileVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
		self.navigationController?.pushViewController(profileVC, animated: true)
	}
}
