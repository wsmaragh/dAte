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
    

	//Properties
	let cellSpacing: CGFloat = 0.6
	var lovers = [Lover](){
		didSet{
			discoverCV.reloadData()
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

	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setUpDiscoverCV()
	}


	private func setUpDiscoverCV() {
		discoverCV.dataSource = self
		discoverCV.delegate = self
        discoverCV.register(UINib(nibName: "DiscoverUserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DiscoverCell")


        let layout = discoverCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 13, 0, 13)
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: discoverCV.frame.size.width * 0.5, height: discoverCV.frame.size.height * 0.45)
	}


	private func loadLovers() {
		getAllLoversExceptCurrent()
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
    let cell = discoverCV.dequeueReusableCell(withReuseIdentifier: "DiscoverCell", for: indexPath) as! DiscoverUserCollectionViewCell
		let lover = lovers[indexPath.row]
		if let image = lover.profileImageUrl {
			cell.userImageView.loadImageUsingCacheWithUrlString(image)
		} else {
			cell.userImageView.image = #imageLiteral(resourceName: "user2")
		}
        cell.nameLabel.text = lover.name
        cell.layoutSubviews()
		return cell
	}
}


//MARK - UICollectionView Delegate
extension DiscoverVC: UICollectionViewDelegate {

}


//MARK - UICollectionView Flow Layout
extension DiscoverVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		//perform segue to profile here
		 let selectedLover = lovers[indexPath.row]
		let storyboard = UIStoryboard(name: "Profile", bundle: nil)
		let profileVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
        profileVC.visitedUser = selectedLover
		self.navigationController?.pushViewController(profileVC, animated: true)
	}
}
