//
//  AdmirersVC.swift
//  Food+Love
//
//  Created by Gloria Washington on 3/23/18.
//  Copyright © 2018 Gloria Washington. All rights reserved.
//


import UIKit
import Firebase


class AdmirersVC: UIViewController {
    
    @IBOutlet weak var admirerCV: UICollectionView!
    
    var admirers = [Lover]() {
        didSet{
            admirerCV.reloadData()
        }
    }
    var currentLover: Lover! {
        didSet {
            guard currentLover != nil else {return}
            loadData()
            
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViewLayout()
         loadCurrentUser()
        self.navigationItem.title = "Admirers"
				setupNavBar()
    }
    
    private func loadData() {
        guard let followers = self.currentLover.followers else {return}

        let followerUids = Array(followers.values)
      
        Database.database().reference().child("lovers").observe(.value) { (snapshot) in
            var onlineFollowers = [Lover]()
            for child in snapshot.children {
                let childDataSnapshot = child as! DataSnapshot
                let key = childDataSnapshot.key
                if followerUids.contains(key) {
                    if let dict = childDataSnapshot.value as? [String: AnyObject] {
                        let lover = Lover(dictionary: dict)
                        onlineFollowers.append(lover)
                    }
                }
            }
            self.admirers = onlineFollowers
        }
        
    }
    

	private func setupNavBar(){
		let image : UIImage = #imageLiteral(resourceName: "Logo3")
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		self.navigationItem.titleView = imageView
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


    func setUpCollectionViewLayout() {
        admirerCV.dataSource = self
        admirerCV.delegate = self
        admirerCV.register(UINib(nibName: "NewAdmirerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdmirerCell")


        let layout = admirerCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
//        layout.itemSize = CGSize(width: (layout.collectionView?.frame.width)! * 0.8 , height: (layout.collectionView?.frame.height)! * 0.5)
        
        //let layout = admirerCV.collectionViewLayout as! UICollectionViewFlowLayout
        //layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumInteritemSpacing = 32
        //layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: admirerCV.frame.size.height * 0.4)

    }


    
}


extension AdmirersVC: UICollectionViewDataSource, UICollectionViewDelegate {

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: 100, height: 100)
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       let cell = admirerCV.dequeueReusableCell(withReuseIdentifier: "AdmirerCell", for: indexPath) as! NewAdmirerCollectionViewCell

        
        let admirer = admirers[indexPath.row]
        cell.nameLabel.text = admirer.name

        let currentLoverFoods = [currentLover.firstFoodPrefer, currentLover.secondFoodPrefer, currentLover.thirdFoodPrefer]
        let loverFoods = [admirer.firstFoodPrefer, admirer.secondFoodPrefer, admirer.thirdFoodPrefer]
        var common = [String]()
        for option in currentLoverFoods where option != nil {
            if loverFoods.contains(where: {$0 == option}) {
                common.append(option!)
            }
        }
    
        cell.faveCuisinesLabel.text = common.joined(separator: ", ")
        
        if let image = admirer.profileImageUrl {
            cell.userImageView.loadImageUsingCacheWithUrlString(image)
      
        } else {
            cell.userImageView.image = #imageLiteral(resourceName: "profile")
        }
//        cell.contentView.addSubview(button)
        cell.setNeedsLayout()
        return cell
    }


	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return admirers.count
	}


}

extension AdmirersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "UserProfileVC") as! UserProfileTableViewController
        let admirer = admirers[indexPath.row]
        profileVC.lover = admirer
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let viewWidth = view.bounds.width * 0.95
        let viewHeight = view.bounds.height * 0.35
        return CGSize(width: viewWidth, height: viewHeight)
    }
}
