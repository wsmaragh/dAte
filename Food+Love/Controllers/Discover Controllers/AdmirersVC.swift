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
    
    //Maybe move this? - G.W.
    func getAllLoversExceptCurrent() {
        DispatchQueue.main.async {
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

        if let image = admirer.profileImageUrl {
            cell.userImageView.loadImageUsingCacheWithUrlString(image)
            cell.userImageView.layer.cornerRadius = cell.userImageView.frame.width / 2
            cell.favoriteFoodImageView.layer.cornerRadius = cell.favoriteFoodImageView.frame.width / 2

        } else {
            cell.userImageView.image = #imageLiteral(resourceName: "user2")
        }
//        cell.contentView.addSubview(button)
        cell.setNeedsLayout()
        return cell
    }


	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return admirers.isEmpty ? 0 : admirers.count
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
