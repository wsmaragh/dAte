//
//  UserDetailTableViewController.swift
//  RecreateDemoCells
//
//  Created by C4Q on 4/4/18.
//  Copyright © 2018 Glo. All rights reserved.
//

import UIKit
import expanding_collection
import Firebase

class UserDetailTableViewController: ExpandingTableViewController {
    
    @IBOutlet weak var shareFoodLabel: UILabel!
    @IBOutlet weak var favoriteCuisineCollectionView: UICollectionView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var boroughLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var favoriteFoodImageView: UIImageView!
    @IBOutlet weak var favoriteFoodName: UILabel!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var lookingForTextView: UITextView!
    @IBOutlet weak var aboutMeBackgroundView: UIView!
    @IBOutlet weak var lookingForBackgroundView: UIView!
    
    var lover: Lover? {
        didSet {
            //          favoriteFoodName.text = lover?.favDish ?? ""
            //            aboutMeTextView.text = lover?.bio ?? ""
            //            lookingForTextView.text = lover?.bio ?? ""
        }
    }
    
    var currentFoods: [String]?
    
    var currentLover: Lover? {
        didSet {
            guard let following = currentLover?.following else {
                self.likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                return
            }
            for (_, value) in following {
                if value == lover!.id {
                    self.likeButton.setImage(#imageLiteral(resourceName: "like_filled"), for: .normal)
                }
            }
        }
    }
    
    var cuisines = [ "Thai", "Japanese", "Burgers", "Fried Chicken"]
    
    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = #imageLiteral(resourceName: "bg_love1")
        self.navigationItem.setHidesBackButton(true, animated:true)
        tableView.backgroundView = UIImageView(image: image1)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        configureNavBar()
        favoriteCuisineCollectionView.dataSource = self
        favoriteCuisineCollectionView.delegate = self
        loadData()
        loadCurrentUser()
    }
    
    
    func convertBirthDayToAge() -> Int? {
        var myAge: Int?
        // let myDOB = Calendar.current.date(from: DateComponents(year: 1970, month: 9, day: 10))!
        if let ageArr = self.lover?.dateOfBirth?.components(separatedBy: "-") {
            guard let year =  Int(ageArr[0]), let month = Int(ageArr[1]), let day = Int(ageArr[2]) else {
                return nil
            }
            let myDOB = Calendar.current.date(from: DateComponents(year: year, month: month, day: day))!
            myAge = myDOB.age
        }
        return myAge
    }
    
    
    private func loadData() {
        favoriteFoodName.text = lover?.favDish ?? ""
        aboutMeTextView.text = lover?.bio ?? ""
        lookingForTextView.text = "Someone who is ready to be an amazing partner and accept an amazing partner into their life "
        favoriteFoodImageView.image = UIImage(named: lover?.favDish ?? "bg_coffee")
        ageLabel.text = convertBirthDayToAge()?.description ?? "30"
        boroughLabel.text = "Brooklyn"
        
        let currentLoverFoods = [currentLover?.firstFoodPrefer, currentLover?.secondFoodPrefer, currentLover?.thirdFoodPrefer]
        let loverFoods = [lover?.firstFoodPrefer, lover?.secondFoodPrefer, lover?.thirdFoodPrefer]
//        var common = [String]()
//        for option in currentLoverFoods where option != nil {
//            if loverFoods.contains(where: {$0 == option}) {
//                common.append(option!)
//            }
//        }
        shareFoodLabel.text = currentFoods?.joined(separator: ", ")
        self.cuisines = loverFoods as! [String]
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
    
    override func viewWillAppear(_ animated: Bool) {
        // Sets the status bar to hidden when the view has finished appearing
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Sets the status bar to visible when the view is about to disappear
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.isHidden = false
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let views = [aboutMeBackgroundView, lookingForBackgroundView] as [UIView]
        views.forEach {
            $0.layer.cornerRadius = 8
            $0.layer.masksToBounds = true
            $0.layer.backgroundColor = UIColor.white.cgColor //Needed to set cell color here so it does not take on table view background. Do for both layers!
            $0.layer.masksToBounds = false
            $0.layer.shadowOffset = CGSize(width: 4, height: 4)
            $0.layer.shadowColor = UIColor.lightGray.cgColor
            $0.layer.shadowOpacity = 0.2
            $0.layer.shadowRadius = 4    }
        
    }
    
    
    
    @IBAction func likeButton(_ sender: Any) {
        //Add like functionality here
        let button = sender as! UIButton
        guard self.currentLover != nil, self.lover != nil else {return}
        let uid = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        let key = ref.child("lovers").childByAutoId().key // autoId key
        
        // if following, remove value from lover, remove from currentLover's following
        if button.imageView?.image == #imageLiteral(resourceName: "like_filled") {
            ref.child("lovers").child(uid).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                if let following = snapshot.value as? [String: AnyObject] {
                    for (ke, value) in following {
                        if value as! String == self.lover!.id {
                            self.likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
                            
                            ref.child("lovers").child(uid).child("following/\(ke)").removeValue()
                            ref.child("lovers").child(self.lover!.id).child("followers/\(ke)").removeValue()
                        }
                    }
                }
                
            })
            //  ref.removeAllObservers()
            
        }
        else {
            // if not following, add to currentLover's following, lover's followers
            let following = ["following/\(key)": self.lover!.id]
            let followers = ["followers/\(key)": uid]
            ref.child("lovers").child(uid).updateChildValues(following)
            ref.child("lovers").child(self.lover!.id).updateChildValues(followers)
            
            likeButton.setImage(#imageLiteral(resourceName: "like_filled"), for: .normal)
            guard let loverName = lover?.name else {return}
            guard let currentUserName = Auth.auth().currentUser?.displayName else {return}
            FCMAPIClient.manager.sendPushNotification(device: "f5bPV5St5_Q:APA91bECWGZPtztlokyhz8dntC-nsQA-4Oe83CNPhzkpt_CJCcX87SPxYhl5QwKQCm3mDosS521zI2rdXliiIu0x6Td-MyePO6cEnTBNdgcpDcvidNWz5mtte_naClzeLRyGp47GJqaK", title: "dAte", message: "Hey \(loverName), \(currentUserName) likes YOU!")
            
        }
        ref.removeAllObservers()
    }
    
}




extension UserDetailTableViewController {
    
    fileprivate func configureNavBar() {
        //        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.title = lover?.name
    }
}


extension UserDetailTableViewController {
    
    @IBAction func backHandler(_: AnyObject) {
        // buttonAnimation
        let viewControllers: [UserViewController?] = navigationController?.viewControllers.map { $0 as? UserViewController } ?? []
        
        for viewController in viewControllers {
            if let rightButton = viewController?.navigationItem.rightBarButtonItem as? AnimatingBarButton {
                rightButton.animationSelected(false)
            }
        }
        popTransitionAnimation()
    }
}


extension UserDetailTableViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -25 , let navigationController = navigationController {
            // buttonAnimation
            for case let viewController as UserViewController in navigationController.viewControllers {
                if case let rightButton as AnimatingBarButton = viewController.navigationItem.rightBarButtonItem {
                    rightButton.animationSelected(false)
                }
            }
            popTransitionAnimation()
        }
        scrollOffsetY = scrollView.contentOffset.y
    }
}


extension UserDetailTableViewController {
    
}

extension UserDetailTableViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cuisines.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == favoriteCuisineCollectionView {
            let cell = favoriteCuisineCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCuisineCell", for: indexPath) as! FaveFoodsCollectionViewCell
            let cuisine = cuisines[indexPath.row]
            cell.sizeThatFits(CGSizeFromString(cuisine))
            cell.configureCell(food: cuisine)
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Add functionality of adding food preferences when clicked
    }
    
    //        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //            let cuisine = cuisines[indexPath.row]
    //            return CGSizeFromString(cuisine)
    //        }
    
}
