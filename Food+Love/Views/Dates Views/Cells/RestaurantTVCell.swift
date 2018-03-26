//
//  RestaurantTVCell.swift
//  myCalender2
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit

class RestaurantTVCell: UITableViewCell {
    
    lazy var restaurantLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    lazy var addresRestLabel: UILabel = {
        let label = UILabel()
        label.textColor = Colors.black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 12)
        return label
    }()
    
    lazy var verticalStackV: UIStackView = {
        let stView = UIStackView()
        stView.axis  = UILayoutConstraintAxis.vertical
        stView.distribution  = UIStackViewDistribution.fillEqually
        stView.alignment = UIStackViewAlignment.leading
        stView.spacing   = 8.0
        stView.translatesAutoresizingMaskIntoConstraints = false
        return stView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configCell(venue: Venue) {
        setupViews()
        restaurantLabel.text = venue.name
        addresRestLabel.text = venue.location.address ?? "No address"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupViews() {
        addSubview(verticalStackV)
        verticalStackV.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        verticalStackV.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        verticalStackV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        verticalStackV.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        
        verticalStackV.addArrangedSubview(restaurantLabel)
        verticalStackV.addArrangedSubview(addresRestLabel)
    }

}
