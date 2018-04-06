//
//  UserDetailTableViewController.swift
//  RecreateDemoCells
//
//  Created by C4Q on 4/4/18.
//  Copyright © 2018 Glo. All rights reserved.
//

import UIKit
import expanding_collection

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
    
    
    let cuisines = [ "Thai", "Japanese", "Burgers", "Fried Chicken"]
    
    fileprivate var scrollOffsetY: CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let image1 = #imageLiteral(resourceName: "bg_love1")
        tableView.backgroundView = UIImageView(image: image1)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        configureNavBar()
        favoriteCuisineCollectionView.dataSource = self
        favoriteCuisineCollectionView.delegate = self
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
}


extension UserDetailTableViewController {
    
    fileprivate func configureNavBar() {
//        navigationItem.leftBarButtonItem?.image = navigationItem.leftBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationItem.rightBarButtonItem?.image = navigationItem.rightBarButtonItem?.image!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
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
