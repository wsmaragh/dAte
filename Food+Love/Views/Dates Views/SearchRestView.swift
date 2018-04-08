//
//  SearchRestView.swift
//  myCalender2
//
//  Created by C4Q on 3/25/18.
//  Copyright © 2018 akhil. All rights reserved.
//

import UIKit

@objc protocol SearchRestViewDelegate: class {
    @objc optional func didItemSelect(venueId: String, rest: String, address: String)
}

class SearchRestView: UIView {
    
    weak var delegate: SearchRestViewDelegate?
    
    var venues = [Venue]() {
        didSet {
            DispatchQueue.main.async {
                self.searchRestTV.reloadData()
            }
        }
    }
    
    lazy var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "Search a restaurant ... "
        return search
    }()
    
    lazy var searchRestTV: UITableView = {
        let cv = UITableView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(RestaurantTVCell.self, forCellReuseIdentifier: "cell")
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        self.backgroundColor = Colors.black
        self.layer.opacity = 0.0
        searchRestTV.delegate = self
        searchRestTV.dataSource = self
        searchBar.delegate = self
        loadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadData() {
        //40.669998, -73.978747
        FSSearchAPIClient.manager.getVenues(lat: "40.669998", long: "-73.978747", distance: "500", completion: { (venuesOnline) in
            if let venues = venuesOnline {
                self.venues = venues
            }
        }) { (error) in
            if let error = error {
                print(error)
            }
        }
    }
    
    private func setupViews() {
        addSubview(searchBar)
        searchBar.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        searchBar.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        addSubview(searchRestTV)
        searchRestTV.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        searchRestTV.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        searchRestTV.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        searchRestTV.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}

extension SearchRestView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Manhattan: 40.762243, -73.982661
        if let searchTerm = searchBar.text {
            FSSearchAPIClient.manager.searchVenues(search: searchTerm, lat: "40.669998", long: "-73.978747", distance: "250", completion: { (venuesOnline) in
                if let venues = venuesOnline {
                    self.venues = venues
                }
            }) { (error) in
                if let error = error {
                    print(error)
                }
            }
        }
        
        return true
    }
}

extension SearchRestView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let venue = self.venues[indexPath.row]
        delegate?.didItemSelect!(venueId: venue.id,rest: venue.name, address: venue.location.address ?? "No address")
        self.endEditing(true)
    }
}

extension SearchRestView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? RestaurantTVCell {
            let restaurant = venues[indexPath.row]
            cell.configCell(venue: restaurant)
            return cell
        }
        return UITableViewCell()
    }
    
    
}
