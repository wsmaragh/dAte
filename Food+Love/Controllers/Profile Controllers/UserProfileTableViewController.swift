//
//  UserProfileTableViewController.swift
//  Food+Love
//
//  Created by C4Q on 3/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserProfileTableViewController: UITableViewController {
    
    
    init(lover: Lover) {
        super.init(nibName: nil, bundle: nil)
        self.lover = lover
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var lover: Lover?
    private var profileImages: [UIImage] = [#imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "profile")] {
        didSet {
            DispatchQueue.main.async {
                self.userPhotosCollectionView.reloadData()
            }
        }
    }
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
            loadImages()
        }
    }
    
    var photos = [#imageLiteral(resourceName: "bg_cook"), #imageLiteral(resourceName: "bg_love1"), #imageLiteral(resourceName: "bg_date2"), #imageLiteral(resourceName: "bg_desert")]
//    var cuisines = ["Thai", "Japanese", "Nigerian", "Coffee", "Tacoes"]
    
    @IBOutlet weak var favoriteCuisinesCollectionView: UICollectionView!
    @IBOutlet weak var lookingForTextView: UITextView!
    
    @IBOutlet weak var lookingForBackgroundView: UIView!
    @IBOutlet weak var faveRestaurantTextView: UITextView!
    @IBOutlet weak var aboutMeBackgroundView: UIView!
    @IBOutlet weak var favoriteRestaurantBackgroundView: UIView!
    @IBOutlet weak var aboutMeTextView: UITextView!
    @IBOutlet weak var favoriteFoodLabel: UILabel!
    @IBOutlet weak var favoriteFoodImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhotosCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        favoriteCuisinesCollectionView.dataSource = self
        favoriteCuisinesCollectionView.delegate = self
        userPhotosCollectionView.dataSource = self
        userPhotosCollectionView.delegate = self
//        setUpPagerView()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadCurrentUser()
        loadData()
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
    func loadImages() {
        
        guard self.lover != nil else {return}
        let url0 = lover!.profileImageUrl ?? ""
        let url1 = lover!.profileImageUrl1 ?? ""
        let url2 = lover!.profileImageUrl2 ?? ""
        
        ImageHelper.manager.getImage(from: url0, completionHandler: {
            self.profileImages[0] = $0
        }, errorHandler: {_ in })
        ImageHelper.manager.getImage(from: url1, completionHandler: {
            self.profileImages[1] = $0
        }, errorHandler: {_ in })
        ImageHelper.manager.getImage(from: url2, completionHandler: {
            self.profileImages[2] = $0
        }, errorHandler: {_ in })
        // self.profileImages = [image1, image2, image3]
    }

    private func loadData() {
        userNameLabel.text = lover?.name ?? "N/A"
        if let age = convertBirthDayToAge() {
        ageLabel.text = "Age: \(age)"
        } else {
            ageLabel.text = "Age: N/A"
        }
        userLocationLabel.text = lover?.city ?? "USA"
        favoriteFoodLabel.text = lover?.favDish ?? "N/A"
        aboutMeTextView.text = lover?.bio ?? "User hasn't say anything yet, start a dialoge to find out more."
       // faveRestaurantTextView.text = lover?.favRestaurants?[0] ?? "N/A"
    
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
            FCMAPIClient.manager.sendPushNotification(device: "cdqO_3YCQSE:APA91bGaCppkbnGIqxZ3NFygho_vNyPc8ptaj5K1cGJAtVTljg3an6bj0cr53GupeEvooZoabehnf4uE3L6EiMIrcvFkc-_REyZrrN5TvtTXS4Al7dRa1ydVylJoFN2FV1to14FcMBGE", title: "dAte", message: "Hey \(loverName), \(currentUserName) likes YOU!")
          
        }
        ref.removeAllObservers()
    }
//    private func setUpPagerView() {
//                userPhotosView.dataSource = self
//                userPhotosView.delegate = self
//                userPhotosView.transformer = FSPagerViewTransformer(type: .depth)
//    }
    
 
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
      //  let views = [favoriteRestaurantBackgroundView, lookingForBackgroundView, aboutMeBackgroundView] as [UIView]
        let views = [lookingForBackgroundView, aboutMeBackgroundView] as [UIView]
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
    // MARK: - Table view data source

   public func convertBirthDayToAge() -> Int? {
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
    

    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let view = UITableViewHeaderFooterView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
//        view.contentView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 0)
//        view.contentView.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 0)
//        let label = UILabel.init(frame: CGRect.init(x: 20, y: 0, width: tableView.bounds.width, height: tableView.sectionHeaderHeight))
//        label.font = UIFont(name: "Futura", size: 11)
//        label.textColor = UIColor.blue
//        view.addSubview(label)
//        label.tag = 1000
//        return view
//    }
//    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//
//        let header = view as! UITableViewHeaderFooterView
//        let label = header.viewWithTag(1000) as? UILabel
//        label?.font = UIFont(name: "Futura", size: 15)
//
//        switch section {
//        case 2:
//            label?.text = "Favorite Restaurant!"
//        case 3:
//            label?.text = "Favorite Cuisines"
//        default:
//            break
//        }
//    }

    
}

extension UserProfileTableViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == favoriteCuisinesCollectionView {
        return 3
        }
        return profileImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == userPhotosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OtherUserProfileCell", for: indexPath) as! OtherUserProfileCollectionCell
            
            cell.otherUserImageView.image  = self.profileImages[indexPath.row]
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCuisineCell", for: indexPath) as! FaveFoodCollectionViewCell
        
        let cuisines = ["cafes", "japanese", "Chinese"]
            let cuisine = cuisines[indexPath.row]
            cell.faveFoodLab.text = cuisine
        return cell
//        if collectionView == favoriteCuisinesCollectionView {
//        let cell = favoriteCuisinesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCuisineCell", for: indexPath) as! FaveFoodCollectionViewCell
//        let cuisine = cuisines[indexPath.row]
//        cell.configureCell(food: cuisine)
//        return cell
//
//        }
 
    }
    
  
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cuisine = cuisines[indexPath.row]
//        return CGSizeFromString(cuisine)
//    }
    
}

//extension UserProfileTableViewController: FSPagerViewDataSource, FSPagerViewDelegate {
//
//    //MARK: Sets Up Number of Circles in Page Control
//    internal func numberOfItems(in pagerView: FSPagerView) -> Int {
//        //return user images count
//        return photos.count
//    }
//
//    //MARK: Sets up images in scroll view
//    internal func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
//        let photo = photos[index]
//        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
//        cell.imageView?.image = photo
//        cell.imageView?.contentMode = .scaleAspectFit
//        return cell
//    }
//
//}

