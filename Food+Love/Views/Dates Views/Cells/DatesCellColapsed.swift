//
//  DatesCellColapsed.swift
//  Food+Love
//
//  Created by C4Q on 4/5/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DatesCellColapsed: UITableViewCell {
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.layer.opacity = 0.7
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blur
    }()
    
    lazy var calendarImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = #imageLiteral(resourceName: "icoCalendar_128x128")
        return image
    }()
    
    lazy var dayCalendarLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = Colors.red
        label.text = "23"
        return label
    }()
    
    lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 8)
        label.text = "Tuesday"
        return label
    }()
    
    lazy var loverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "With: "
        return label
    }()
    
    lazy var loverPhoto: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = Colors.red.cgColor
        image.layer.shadowColor = Colors.darkGray.cgColor
        image.layer.shadowOffset = CGSize(width: 5.0, height: 10.0)
        return image
    }()
    
    lazy var restaurantLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "El taco loco"
        return label
    }()
    
    func configureCell(planDate: PlanDate) {
        setupConstraints()
        dayCalendarLabel.text = planDate.dayId
        restaurantLabel.text = planDate.restaurant ?? "No restaurant"
        guard let loverTo = planDate.loverTo else {print("No lover");return}
        let ref = Database.database().reference().child("lovers").child(loverTo)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! [String: AnyObject]
            let lover = Lover(dictionary: value)
            self.loverLabel.text = "With: \(lover.name)"
            guard let loverPhotoUrl = lover.profileImageUrl else {print("No picture of the user");return}
            self.loverPhoto.loadImageUsingCacheWithUrlString(loverPhotoUrl)
        }
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        self.loverPhoto.layer.cornerRadius = self.loverPhoto.frame.size.width / 2
    }

    private func setupConstraints() {
        //--- BlurView ---//
        addSubview(blurEffectView)
        blurEffectView.frame = self.bounds
        
        addSubview(calendarImageView)
        calendarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        calendarImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        calendarImageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        calendarImageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        calendarImageView.addSubview(dayCalendarLabel)
        dayCalendarLabel.centerXAnchor.constraint(equalTo: calendarImageView.centerXAnchor).isActive = true
        dayCalendarLabel.centerYAnchor.constraint(equalTo: calendarImageView.centerYAnchor, constant: 16).isActive = true
        
        calendarImageView.addSubview(weekDayLabel)
        weekDayLabel.topAnchor.constraint(equalTo: dayCalendarLabel.bottomAnchor, constant: 2).isActive = true
        weekDayLabel.centerXAnchor.constraint(equalTo: dayCalendarLabel.centerXAnchor).isActive = true
        
        
        addSubview(loverPhoto)
        loverPhoto.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        loverPhoto.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        loverPhoto.widthAnchor.constraint(equalToConstant: 64).isActive = true
        loverPhoto.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        
        addSubview(loverLabel)
        loverLabel.centerYAnchor.constraint(equalTo: loverPhoto.bottomAnchor).isActive = true
        loverLabel.centerXAnchor.constraint(equalTo: loverPhoto.centerXAnchor).isActive = true
        
        addSubview(restaurantLabel)
        restaurantLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        restaurantLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
    }
}
