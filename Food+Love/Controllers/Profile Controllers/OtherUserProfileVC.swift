//
//  OtherUsersProfileVC.swift
//  Food+Love
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import FSPagerView

class OtherUserProfileVC: UIViewController {

    var visitedUser: Lover! {
        didSet{
            print(visitedUser.name!)
        }
    }
    var photos = [#imageLiteral(resourceName: "bg_cook"), #imageLiteral(resourceName: "bg_love1"), #imageLiteral(resourceName: "bg_date2"), #imageLiteral(resourceName: "bg_desert")]
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    @IBOutlet weak var pageControl: FSPageControl!
    @IBOutlet weak var favoriteRestaurantTV: UITableView!
    @IBOutlet weak var favoriteFoodsCV: UICollectionView!
    @IBOutlet weak var searchingForTV: UITableView!
    @IBOutlet weak var bioTV: UITableView!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var LocationLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "User Nme"

        setUpTableViews()
        setUpPagerView()
        setUpPageControl()
        setUpFoodCollectionView()
        setUpTableViews()
        setUpButton()
    }

    private var foodLabel = ["Thai", "Japanese", "Tacoes", "Estonian", "Welsh"]

    private func setUpTableViews() {
        favoriteRestaurantTV.dataSource = self
        bioTV.dataSource = self
        searchingForTV.dataSource = self
    }
    
    private func setUpPageControl() {
        pageControl.numberOfPages = photos.count
        pageControl.setFillColor(.gray, for: .normal)
        pageControl.setFillColor(.lightGray , for: .selected)
    }
    
    private func setUpPagerView() {
        pagerView.dataSource = self
        pagerView.delegate = self
        pagerView.transformer = FSPagerViewTransformer(type: .depth)
    }
    
    private func setUpFoodCollectionView() {
        favoriteFoodsCV.delegate = self
        favoriteFoodsCV.dataSource = self
        let layout = favoriteFoodsCV.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5)
        layout.minimumInteritemSpacing = 1
        
    }

    private func setUpButton() {
        likeButton.layer.cornerRadius = 10
        likeButton.layer.masksToBounds = true
        
    }


    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}

extension OtherUserProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodLabel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = favoriteFoodsCV.dequeueReusableCell(withReuseIdentifier: "FaveFoodsCell", for: indexPath) as! FaveFoodCollectionViewCell
        let favFood = foodLabel[indexPath.row]
//        cell.faveFoodLab.text = favFood
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    


//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let foodTitle = foodLabel[indexPath.row]
//        let cGValue = CGSizeFromString(foodTitle)
//        return cGValue
//    }
}


extension OtherUserProfileVC: FSPagerViewDataSource, FSPagerViewDelegate {
    
    //MARK: Sets Up Number of Circles in Page Control
    internal func numberOfItems(in pagerView: FSPagerView) -> Int {
        //return user images count
        return photos.count
    }
    
    //MARK: Sets up images in scroll view
    internal func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let photo = photos[index]
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = photo
        cell.imageView?.contentMode = .scaleAspectFit
        pageControl.currentPage = index
        return cell
    }
    
}
