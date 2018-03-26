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

	override func viewWillAppear(_ animated: Bool) {
		loadData()
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		setUpCollectionViewLayout()

	}

	private func loadData() {
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
		return admirers.isEmpty ? 0 : admirers.count
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
		let selectedLover = admirers[indexPath.row]
		let storyboard = UIStoryboard(name: "Profile", bundle: nil)
		let profileVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
		profileVC.lover = selectedLover
		self.navigationController?.pushViewController(profileVC, animated: true)
	}
}
