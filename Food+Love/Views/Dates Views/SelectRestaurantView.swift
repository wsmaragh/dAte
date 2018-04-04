//
//  MakeDateView.swift
//  myCalender2
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit

class SelectRestaurantView: UIView {
    
    lazy var restaurantButton: UIButton = {
        let button = UIButton()
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(#imageLiteral(resourceName: "icoRest_32x32"), for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.layer.borderColor = Colors.black.cgColor
        button.layer.shadowColor = Colors.white.cgColor
        button.layer.shadowOpacity = 2
        button.layer.shadowOffset = CGSize(width: 1, height: 2)
        button.layer.borderWidth = 2
        button.backgroundColor = Colors.white
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Colors.white
        label.text = "Date: "
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dateInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Colors.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Colors.white
        label.text = "Hour: "
        label.numberOfLines = 0
        return label
    }()
    
    lazy var hourInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Colors.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var restaurantLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Colors.white
        label.text = "Restaurant: "
        label.numberOfLines = 0
        return label
    }()
    
    lazy var restaurantInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Colors.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Colors.white
        label.text = "Address:"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var addressInfo: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = Colors.white
        label.numberOfLines = 0
        return label
    }()
    
    lazy var mainStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis  = UILayoutConstraintAxis.vertical
        stView.distribution  = UIStackViewDistribution.fillProportionally
        stView.alignment = UIStackViewAlignment.leading
        stView.spacing   = 8.0
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()
    
    lazy var dateStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis  = UILayoutConstraintAxis.horizontal
        stView.distribution  = UIStackViewDistribution.fillEqually
        stView.alignment = UIStackViewAlignment.leading
        stView.spacing   = 8.0
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()
    
    lazy var hourStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis  = UILayoutConstraintAxis.horizontal
        stView.distribution  = UIStackViewDistribution.fillEqually
        stView.alignment = UIStackViewAlignment.leading
        stView.spacing   = 8.0
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()
    
    lazy var restaurantStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis  = UILayoutConstraintAxis.horizontal
        stView.distribution  = UIStackViewDistribution.fillEqually
        stView.alignment = UIStackViewAlignment.leading
        stView.spacing   = 8.0
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()
    
    lazy var addressStackView: UIStackView = {
        let stView = UIStackView()
        stView.axis  = UILayoutConstraintAxis.horizontal
        stView.distribution  = UIStackViewDistribution.fillEqually
        stView.alignment = UIStackViewAlignment.leading
        stView.spacing   = 8.0
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.backgroundColor = Colors.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
        restaurantButton.layer.cornerRadius = 30
    }
    
    private func setupViews() {
//        addSubview(restaurantButton)
//        restaurantButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        restaurantButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
//        restaurantButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
//        restaurantButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        addSubview(mainStackView)
        mainStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 32).isActive = true
        mainStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        
        mainStackView.addArrangedSubview(dateStackView)
        mainStackView.addArrangedSubview(hourStackView)
        mainStackView.addArrangedSubview(restaurantStackView)
        mainStackView.addArrangedSubview(addressStackView)
        
        restaurantStackView.addArrangedSubview(restaurantLabel)
        restaurantStackView.addArrangedSubview(restaurantInfo)
        
        dateStackView.addArrangedSubview(dateLabel)
        dateLabel.widthAnchor.constraint(equalTo: restaurantLabel.widthAnchor).isActive = true
        dateStackView.addArrangedSubview(dateInfo)
        
        hourStackView.addArrangedSubview(hourLabel)
        hourLabel.widthAnchor.constraint(equalTo: restaurantLabel.widthAnchor).isActive = true
        hourStackView.addArrangedSubview(hourInfo)
        
        addressStackView.addArrangedSubview(addressLabel)
        addressLabel.widthAnchor.constraint(equalTo: restaurantLabel.widthAnchor).isActive = true
        addressStackView.addArrangedSubview(addressInfo)
    }
}


