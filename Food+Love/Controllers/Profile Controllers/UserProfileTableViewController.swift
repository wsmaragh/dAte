//
//  UserProfileTableViewController.swift
//  Food+Love
//
//  Created by C4Q on 3/27/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit

class UserProfileTableViewController: UITableViewController {
    
    
    init(lover: Lover) {
        super.init(nibName: nil, bundle: nil)
        self.lover = lover
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var lover: Lover?
    var photos = [#imageLiteral(resourceName: "bg_cook"), #imageLiteral(resourceName: "bg_love1"), #imageLiteral(resourceName: "bg_date2"), #imageLiteral(resourceName: "bg_desert")]
    var cuisines = ["Thai", "Japanese", "Nigerian", "Coffee", "Tacoes"]
    
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
//        setUpPagerView()
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadData()
    }
    
    
    private func loadData() {
        userNameLabel.text = lover?.name ?? "N/A"
        ageLabel.text = "N/A"
        userLocationLabel.text = lover?.city ?? "Somewhere in NYC"
        favoriteFoodLabel.text = "Coffee"
        aboutMeTextView.text = "This is where you write anything about yourself. Keep it short and sweet!"
        lookingForTextView.text = "This is where you tell people what kind of relationship you are searching on here for. Keep it short and simple stupid!"
        faveRestaurantTextView.text = "Katz Delicatessan"
        favoriteCuisinesCollectionView.dataSource = self
        favoriteCuisinesCollectionView.delegate = self
        
        
    }
    
    @IBAction func likeButton(_ sender: Any) {
        //Add like functionality here
        let button = sender as! UIButton
        if button.imageView?.image == #imageLiteral(resourceName: "like_filled") {
            likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        }
        else {
            likeButton.setImage(#imageLiteral(resourceName: "like_filled"), for: .normal)
        }
    }
//    private func setUpPagerView() {
//                userPhotosView.dataSource = self
//                userPhotosView.delegate = self
//                userPhotosView.transformer = FSPagerViewTransformer(type: .depth)
//    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let views = [favoriteRestaurantBackgroundView, lookingForBackgroundView, aboutMeBackgroundView] as [UIView]
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
        return cuisines.count
        }
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == favoriteCuisinesCollectionView {
        let cell = favoriteCuisinesCollectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCuisineCell", for: indexPath) as! FaveFoodCollectionViewCell
        let cuisine = cuisines[indexPath.row]
        cell.configureCell(food: cuisine)
        return cell
        
        }
    
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Add functionality of adding food preferences when clicked
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

