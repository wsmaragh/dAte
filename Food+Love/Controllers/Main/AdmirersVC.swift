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

	var admirers = ["Mary", "Philomena", "Raven", "Tessa", "Julie"]

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpCollectionViewLayout()



	}

	private func loadData() {

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
		cell.admirerNameLabel.text = admirer
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
