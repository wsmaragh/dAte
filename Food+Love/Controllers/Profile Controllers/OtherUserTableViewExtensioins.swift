//
//  ProfileTableViewExtensioins.swift
//  Food+Love
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import Foundation
import UIKit

extension OtherUserProfileVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //add text for cell
        if tableView == favoriteRestaurantTV {
            let cell = Bundle.main.loadNibNamed("FavoriteRestaurantTableViewCell", owner: self, options: nil)?.first as! FavoriteRestaurantTableViewCell
            cell.layer.cornerRadius = 10
            let shadowPath2 = UIBezierPath(rect: cell.bounds)
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(3.0))
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = shadowPath2.cgPath
            cell.favoriteRestaurantTV.text = "Lombardis"
            cell.layoutSubviews()
            return cell

        }

        if tableView == bioTV {
            ///Put what goes in text here
            let cell =  Bundle.main.loadNibNamed("AnswerTableViewCell", owner: self, options: nil)?.first as! AnswerTableViewCell
           cell.answerTextView.text = "I am a loving, caring person who loves to go out and enjoy life."
            return cell
        }
        //add text for cell here
        let cell = Bundle.main.loadNibNamed("AnswerTableViewCell", owner: self, options: nil)?.first as! AnswerTableViewCell
        cell.answerTextView.text = "I'm looking for someone with a big heart."
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableView == favoriteRestaurantTV {
            return "Favorite Restaurants"
        }
        if tableView == bioTV {
            return "I am..."
        }
        return "I'm looking for..."
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == favoriteRestaurantTV {
            return 125
    }
        return 300
    
    }
    
}


class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }

    private func setupShadow() {
        self.layer.cornerRadius = 8
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.3
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension String {
    //Get date
    func calcAge(birthday: String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MM/dd/yyyy"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
        let now = Date()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
        let age = calcAge.year
        return age!
    }
}
