//
//  RestaurantViewController.swift
//  Food+Love
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailViewController: UIViewController {
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var menuSnapShotTableView: UITableView!
    @IBOutlet weak var shareRestaurantButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuSnapShotTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    @IBAction func sharedButtonPressed(_ sender: UIButton) {
        
    }

}

extension RestaurantDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}


