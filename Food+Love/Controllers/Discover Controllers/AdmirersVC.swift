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
    
    //    @IBOutlet weak var admirerCV: UICollectionView!
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
        admirerCV.dataSource = self
        admirerCV.delegate = self
        admirerCV.register(UINib(nibName: "AdmirerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AdmirerCell")

        
        
    }
    
}


extension AdmirersVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return admirers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = admirerCV.dequeueReusableCell(withReuseIdentifier: "AdmirerCell", for: indexPath) as! AdmirerCollectionViewCell
        
        let admirer = admirers[indexPath.row]
        cell.nameLabel.text = admirer.name
        if let image = admirer.profileImageUrl {
            cell.imageView.loadImageUsingCacheWithUrlString(image)
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "user2")
        }
        cell.layoutSubviews()
        return cell
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenHeight: CGFloat = UIScreen.main.bounds.height
        let screenWidth: CGFloat = UIScreen.main.bounds.width
          let cellSpacing: CGFloat = 10
        let numberOfCells: CGFloat = 1.0
        let layout = admirerCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: (screenWidth * 0.8) - (cellSpacing * 2) , height:  (screenHeight / numberOfCells) - (cellSpacing * numberOfCells) + 1)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.minimumLineSpacing = cellSpacing
        layout.minimumInteritemSpacing = cellSpacing
        layout.itemSize = CGSize(width: (layout.collectionView?.frame.width)! * 0.8, height: (layout.collectionView?.frame.height)! * 0.2)
        return CGSize(width: 400, height: 250)
    }
}

extension AdmirersVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Profile", bundle: nil)
        let profileVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileVC") as! OtherUserProfileVC
        let admirer = admirers[indexPath.row]
        profileVC.visitedUser = admirer
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

}
