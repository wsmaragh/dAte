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
    
    //Maybe move this? - G.W.
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


        let layout = admirerCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.itemSize = CGSize(width: (layout.collectionView?.frame.width)! * 0.8 , height: (layout.collectionView?.frame.height)! * 0.7)
        
        //let layout = admirerCV.collectionViewLayout as! UICollectionViewFlowLayout
        //layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        //layout.minimumInteritemSpacing = 0
        //layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: admirerCV.frame.size.height * 0.4)

    }


    
}


extension AdmirersVC: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = admirerCV.dequeueReusableCell(withReuseIdentifier: "AdmirerCell", for: indexPath) as! AdmirerCollectionViewCell
//        let cell = admirerCV.dequeueReusableCell(withReuseIdentifier: "TestingCell", for: indexPath) as! AdmirerCollectionViewCellTesting
        
//        let button : UIButton = UIButton(type: UIButtonType.custom) as UIButton
//        button.frame = CGRect(x: 40, y: 60, width: 100, height: 24)
//        button.addTarget(self, action: #selector(deleteAdmirer), for: UIControlEvents.touchUpInside)
//        button.setTitle("Like", for: UIControlState.normal)
//        button.backgroundColor = .red

        
        let admirer = admirers[indexPath.row]
        cell.nameLabel.text = admirer.name
        if let image = admirer.profileImageUrl {
            cell.imageView.loadImageUsingCacheWithUrlString(image)

        } else {
            cell.imageView.image = #imageLiteral(resourceName: "user2")
        }
        cell.layoutSubviews()
//        cell.contentView.addSubview(button)
        return cell
    }


	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return admirers.isEmpty ? 0 : admirers.count
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 350, height: 150)
    }
}
