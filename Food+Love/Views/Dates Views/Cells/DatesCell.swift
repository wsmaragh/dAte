//
//  DatesView.swift
//  Food+Love
//
//  Created by Marlon Rugama on 3/23/18.
//  Copyright © 2018 Marlon Rugama. All rights reserved.
//

import UIKit
import FirebaseDatabase

class DatesCell: UITableViewCell {

    lazy var backgroundRestImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.layer.opacity = 0.75
        image.clipsToBounds = true
        return image
    }()
    
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
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = Colors.red
        label.text = "23"
        return label
    }()
    
    lazy var weekDayLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 14)
        label.text = "Tuesday"
        return label
    }()
    
    lazy var monthLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont(name: "Arial", size: 11)
        label.text = "April"
        return label
    }()
    
    lazy var restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textAlignment = .center
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .gray
        label.backgroundColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var loverLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "With: "
        return label
    }()
    
    lazy var infoStackView: UIStackView = {
        let stView = UIStackView()
        stView.translatesAutoresizingMaskIntoConstraints = false
        stView.axis  = UILayoutConstraintAxis.vertical
        stView.distribution  = .fillProportionally
        stView.alignment = UIStackViewAlignment.center
        stView.spacing   = 8.0
        return stView
    }()
    
    func configureCell(planDate: PlanDate) {
        setupConstraints()
        guard let venue = planDate.venueId else {print("No venue");return}
        FSPhotoAPIClient.manager.getVenuePhotos(venueID: venue) { (error, photoArr) in
            if let error = error {
                print("Venue photo error:", error)
                return
            }
            guard let prefix = photoArr?.first?.prefix else {print("No prefix");return}
            guard let width = photoArr?.first?.width else {print("No width"); return}
            guard let height = photoArr?.first?.height else {print("No height"); return}
            guard let sufix = photoArr?.first?.suffix else {print("No sufix"); return}
            let imageURL = (prefix + "\(width)" + "x" + "\(height)" + sufix)
            self.backgroundRestImageView.loadImageUsingCacheWithUrlString(imageURL)
        }
        restaurantNameLabel.text = planDate.restaurant
        addressLabel.text = planDate.address
        hourLabel.text = planDate.hour
        monthLabel.text = planDate.monthStr
        dayCalendarLabel.text = planDate.dayId
        
        guard let loverTo = planDate.loverTo else {print("No lover");return}
        let ref = Database.database().reference().child("lovers").child(loverTo)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! [String: AnyObject]
            let lover = Lover(dictionary: value)
            self.loverLabel.text = "With: \(lover.name)"
        }
    }
    
    private func setupConstraints() {
        addSubview(backgroundRestImageView)
        backgroundRestImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        backgroundRestImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        backgroundRestImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundRestImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        
        //--- BlurView ---//
        addSubview(blurEffectView)
        blurEffectView.frame = self.bounds
        
        addSubview(calendarImageView)
        calendarImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        calendarImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        calendarImageView.widthAnchor.constraint(equalToConstant: 128).isActive = true
        calendarImageView.heightAnchor.constraint(equalToConstant: 128).isActive = true
        
        calendarImageView.addSubview(dayCalendarLabel)
        dayCalendarLabel.centerXAnchor.constraint(equalTo: calendarImageView.centerXAnchor).isActive = true
        dayCalendarLabel.centerYAnchor.constraint(equalTo: calendarImageView.centerYAnchor, constant: 16).isActive = true
        
        calendarImageView.addSubview(weekDayLabel)
        weekDayLabel.topAnchor.constraint(equalTo: dayCalendarLabel.bottomAnchor, constant: 2).isActive = true
        weekDayLabel.centerXAnchor.constraint(equalTo: dayCalendarLabel.centerXAnchor).isActive = true
        
        calendarImageView.addSubview(monthLabel)
        monthLabel.bottomAnchor.constraint(equalTo: dayCalendarLabel.topAnchor, constant: 2).isActive = true
        monthLabel.centerXAnchor.constraint(equalTo: dayCalendarLabel.centerXAnchor).isActive = true
        
        addSubview(hourLabel)
        hourLabel.topAnchor.constraint(equalTo: calendarImageView.bottomAnchor, constant: 8).isActive = true
        hourLabel.centerXAnchor.constraint(equalTo: calendarImageView.centerXAnchor, constant: 8).isActive = true
        
        // container: StackView
        addSubview(infoStackView)
        infoStackView.leftAnchor.constraint(equalTo: calendarImageView.rightAnchor, constant: 8).isActive = true
        infoStackView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        infoStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        infoStackView.addArrangedSubview(restaurantNameLabel)
        infoStackView.addArrangedSubview(addressLabel)
        infoStackView.addArrangedSubview(loverLabel)
        
        
    }
}
