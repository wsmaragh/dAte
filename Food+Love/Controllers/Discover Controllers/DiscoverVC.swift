//
//  DiscoverVC.swift
//  Food+Love
//  Created by Gloria Washington on 3/21/18.
//  Copyright © 2018 Gloria Washington. All rights reserved.
//

import UIKit
import Firebase
import Toucan

class DiscoverVC: UIViewController {


	// Outlets
    @IBOutlet weak var discoverCV: UICollectionView!

	//Properties
	let cellSpacing: CGFloat = 0.6
    var currentLover: Lover!
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

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCurrentUser()
			setupNavBar()
        loadLovers()
		setUpDiscoverCV()
	}
 
    func loadCurrentUser() {
        DBService.manager.getCurrentLover { (onlineLover, error) in
            if let lover = onlineLover {
                self.currentLover = lover
            }
            if let error = error {
                print("loading current user error: \(error)")
            }
        }
    }

	private func setUpDiscoverCV() {
		discoverCV.dataSource = self
		discoverCV.delegate = self
        discoverCV.register(UINib(nibName: "NewDiscoverCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NewDiscoverCell")


        let layout = discoverCV.collectionViewLayout as! UICollectionViewFlowLayout
        let padding: CGFloat = 5.0
        layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding)
        layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - (padding * 3)) / 2,
                                 height: UIScreen.main.bounds.height * 0.6)
	}


	private func loadLovers() {
		getAllLoversExceptCurrent()
	}

	private func setupNavBar(){
		let image : UIImage = #imageLiteral(resourceName: "Logo3")
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		self.navigationItem.titleView = imageView
	}




	func getAllLoversExceptCurrent() {
		Database.database().reference().child("lovers").observe(.childAdded, with: { (snapshot) in
			if let dict = snapshot.value as? [String: AnyObject]{
				let lover = Lover(dictionary: dict)
				lover.id = snapshot.key
				if lover.id != Auth.auth().currentUser?.uid && self.currentLover.genderPreference != lover.genderPreference {
                    
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
		return lovers.count
	}


	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = discoverCV.dequeueReusableCell(withReuseIdentifier: "NewDiscoverCell", for: indexPath) as! NewDiscoverCollectionViewCell
        let lover = lovers[indexPath.row]
        cell.layoutIfNeeded()
        cell.userImageView.image = nil
        cell.layoutSubviews()
        cell.userNameLabel.text = lover.name
        cell.favoriteFoodLabel.text = lover.favDish ?? "N/A"
        
        let currentLoverFoods = [currentLover.firstFoodPrefer, currentLover.secondFoodPrefer, currentLover.thirdFoodPrefer]
        let loverFoods = [lover.firstFoodPrefer, lover.secondFoodPrefer, lover.thirdFoodPrefer]
        var common = [String]()
        for option in currentLoverFoods where option != nil {
            if loverFoods.contains(where: {$0 == option}) {
                common.append(option!)
            }
        }
        
        cell.favoriteCuisinesLabel.text = common.joined(separator: ", ")
        if let image = lover.profileImageUrl {
            cell.userImageView.loadImageUsingCacheWithUrlString(image)
        } else {
            cell.userImageView.image = #imageLiteral(resourceName: "profile")
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
		//perform segue to profile here
		 let selectedLover = lovers[indexPath.row]
		let storyboard = UIStoryboard(name: "Profile", bundle: nil)
		let profileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileTableViewController
        profileVC.lover = selectedLover
		self.navigationController?.pushViewController(profileVC, animated: true)
	}
}
