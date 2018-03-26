
//  SearchRestaurant.swift
//  Food+Love
//
//  Created by Winston Maragh on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.


import UIKit
import CoreLocation
import MapKit
import Firebase


class SearchRestaurantVC: UIViewController {

	// MARK: Outlets
	@IBOutlet weak var searchMap: MKMapView!
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var userTrackingButton: MKUserTrackingButton!
	@IBOutlet weak var tableView: UITableView!



	// MARK: Properties
	private var near: String = ""
	private var venues = [Venue]() {
		didSet {
			photoForVenue.removeAll() //empty dictionary before adding new photos
			for venue in venues {
				FSPhotoAPIClient.manager.getVenuePhotos(venueID: venue.id, completion: { (error, onlinePhotoObjects) in
					if let onlinePhotoObjects = onlinePhotoObjects {
						if !onlinePhotoObjects.isEmpty {
							let imageStr = "\(onlinePhotoObjects[0].prefix)500x500\(onlinePhotoObjects[0].suffix)"
							ImageHelper.manager.getImage(from: imageStr, completionHandler: { (onlineImage) in
								self.photoForVenue[venue.id] = onlineImage
								self.tableView.reloadData()
							}, errorHandler: {print($0)})
						}
					}
				})
			}
			addAnnotationsToMap()
		}
	}
	private var photoForVenue: [String: UIImage] = [:] //venueID: UIImage
	private var annotationsForVenues = [MKAnnotation]()
	private var selectedVenue: Venue!
	private var panGesture: UIPanGestureRecognizer!



	// MARK: View Lifecycle
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		setupDelegateAndDatasource()
		configureNavBar()

		if venues.isEmpty { minimizeList()}

		tableView.frame = CGRect(x: 0, y: 400, width: self.view.bounds.width, height: self.view.bounds.height)
		setupLocation()
//		let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
//		let region = MKCoordinateRegionMake(defaultCoordinate, span)
//		searchMap.setRegion(region, animated: true)
		let locationCheck = LocationService.manager.checkForLocationServices()
	}


	//Helper Methods
	fileprivate func setupDelegateAndDatasource() {
		searchMap.delegate = self
		searchBar.delegate = self
		tableView.delegate = self
		tableView.dataSource = self
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(panTableView))
		tableView.addGestureRecognizer(panGesture)
		panGesture.delegate = self
	}

	fileprivate func configureNavBar() {
		navigationItem.title = "Restaurants"
		navigationItem.largeTitleDisplayMode = .always
		navigationItem.titleView = searchBar
		navigationController?.navigationBar.isHidden = false

		//right bar button for toggling between map & list
		let toggleBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "map"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(toggleListAndMap))
		navigationItem.rightBarButtonItem = toggleBarItem
	}

	@objc private func toggleListAndMap() {
		if 	navigationItem.rightBarButtonItem?.image == #imageLiteral(resourceName: "list") {
			showMap()
		} else if navigationItem.rightBarButtonItem?.image == #imageLiteral(resourceName: "map") {
			showList()
		}
	}

	func showMap(){
		navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "mapMarker")
		tableView.isHidden = false
		maximizeList()
	}
	func showList(){
		navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "list")
		minimizeList()
	}


	private func minimizeList(){
		UIView.animate(withDuration: 0.5) {
			self.tableView.frame = CGRect(x: 0, y: self.view.bounds.height * 0.75, width: self.view.bounds.width, height: self.view.bounds.height)
		}
	}

	private func maximizeList(){
		UIView.animate(withDuration: 0.5) {
			self.tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
		}
	}




	@objc private func panTableView(gesture: UIPanGestureRecognizer) {
		let translation = panGesture.translation(in: view)
		panGesture.view?.center = CGPoint(x: panGesture.view!.center.x, y: panGesture.view!.center.y + translation.y)
		panGesture.setTranslation(CGPoint.zero, in: view)
		if tableView.frame.origin.y <= 0.0 {
			tableView.frame = view.bounds
		}
	}


	fileprivate func setupUI() {
		self.view.backgroundColor = #colorLiteral(red: 0.8270000219, green: 0.3529999852, blue: 0.2160000056, alpha: 1)
	}

	private func setupLocation(){
		LocationService.manager.determineMyLocation()
	}

	
	private func addAnnotationsToMap(){
		// creating annotations
		venues.forEach { (venue) in
			let venueAnnotation = venueLocation(coordinate: CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng), title: venue.name, subtitle: venue.contact.formattedPhone ?? "")
			annotationsForVenues.append(venueAnnotation)
		}
		// add annotations to map
		DispatchQueue.main.async {
			self.searchMap.addAnnotations(self.annotationsForVenues)
			self.searchMap.showAnnotations(self.annotationsForVenues, animated: true)
			self.tableView.reloadData()
		}
	}

}



// MARK: SearchBar Delegate
extension SearchRestaurantVC: UISearchBarDelegate {
	//search - enter press
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		//resign keyboard
		searchBar.resignFirstResponder()

		//validate venue search
		guard let venueSearch = searchBar.text else {return}
		guard !venueSearch.isEmpty else {
			let alertController = UIAlertController(title: "Enter a Venue", message: nil, preferredStyle: UIAlertControllerStyle.alert)
			let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
			alertController.addAction(okAction)
			present(alertController, animated: true, completion: nil)
			return
		}
		guard let encodedVenueSearch = venueSearch.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}

		//validate near search
		let encodedNearSearch = ""

		//API Call to get venues
//            FSSearchAPIClient.manager.getVenues(from: encodedVenueSearch, coordinate: "\(searchMap.userLocation.coordinate.latitude),\(searchMap.userLocation.coordinate.longitude)", near:  encodedNearSearch, completion: { (error, OnlineVenues) in
//                if let error = error {print(error); return}
//                self.venues.removeAll()
//                self.searchMap.removeAnnotations(self.annotationsForVenues)
//                self.annotationsForVenues.removeAll()
//                if let onlineVenues = OnlineVenues {
//                    self.venues = onlineVenues
//                }
//            }, errorHandler: {error in
//                if let error = error {
//                    print(error)
//                }
//            })
	}

	func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
		showList()
	}

}


// MARK: MAPVIEW Delegate
extension SearchRestaurantVC : MKMapViewDelegate {
		//view for each annotation
		internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
			//this keeps the user location point as a default blue dot.
			if annotation is MKUserLocation { return nil }

			//setup annotation view for map - we can fully customize the marker
			var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceAnnotationView") as? MKMarkerAnnotationView

			//setup annotation view
			if annotationView == nil {
				annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PlaceAnnotationView")

				//right callout
				annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

				//left callout
				let imageView = UIImageView.init(frame: CGRect(origin: CGPoint(x:0,y:0),size:CGSize(width:30,height:30)))
				imageView.clipsToBounds = true
				imageView.image = UIImage(named: "phone")
				annotationView!.leftCalloutAccessoryView = imageView

				annotationView?.canShowCallout = true
				annotationView?.animatesWhenAdded = true
				annotationView?.markerTintColor = UIColor(red: 238/255, green: 83/255, blue: 80/255, alpha: 1)
				annotationView?.isHighlighted = true
			} else { //display as is
				annotationView?.annotation = annotation
			}
			return annotationView
		}

		//callout tapped/selected
		internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

			//right Callout Accessory
//			if control == view.rightCalloutAccessoryView {
//				control.addTarget(self, action: #selector(callNumber), for: UIControlEvents.allTouchEvents)     //Phone call
//			}
//			//Left Callout Accessory
//			if control == view.leftCalloutAccessoryView {
//				control.addTarget(self, action: #selector(callNumber), for: UIControlEvents.allTouchEvents)     //Phone call
//			}

			//go to detailViewController
//			let detailVC = DetailViewController(venue: selectedVenue, image: photoForVenue[selectedVenue.id]!)
//			navigationController?.pushViewController(detailVC, animated: true)
		}


	//didSelect - setting currentSelected Venue
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		//to change color on annotation already selected
		if let view = view as? MKMarkerAnnotationView {view.markerTintColor = UIColor.lightGray}
		//find venue selected - where they match, pass the index
		let index = annotationsForVenues.index{$0 === view.annotation}
		guard let annotationIndex = index else {print ("index is nil"); return }
		let venue = venues[annotationIndex]
		selectedVenue = venue
	}
}



// MARK: TableView Datasource
extension SearchRestaurantVC: UITableViewDataSource {

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Restaurants: "
	}

	func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
		header.textLabel?.font = UIFont.systemFont(ofSize: 26, weight: UIFont.Weight.bold)
		header.textLabel?.textColor = #colorLiteral(red: 0.8270000219, green: 0.3529999852, blue: 0.2160000056, alpha: 1)
		header.textLabel?.textAlignment = NSTextAlignment.center
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 35
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		var numOfSections: Int = 0
		if venues.count > 0 {
			tableView.backgroundView = nil
			tableView.separatorStyle = .singleLine
			tableView.separatorColor = UIColor.darkGray
			numOfSections = 1
		} else {
			let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 20, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
			noDataLabel.text = "Search for schools by zipcode"
			noDataLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
			noDataLabel.textAlignment = .center
			tableView.backgroundView = noDataLabel
			tableView.backgroundColor = UIColor(red: 242/255, green: 239/255, blue: 199/255, alpha: 1.0)
			tableView.separatorStyle = .none
		}
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return venues.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		//		let cell = searchMapView.tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
		let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "TableViewCell")
		let venue = venues[indexPath.row]
		cell.textLabel?.text = venue.name
		cell.detailTextLabel?.text = venue.location.address ?? ""
		cell.imageView?.image = #imageLiteral(resourceName: "bg_wine2")
//		cell.imageView?.loadImageUsingCacheWithUrlString(venue.url)
		cell.backgroundColor = UIColor.white
		return cell
	}

}


// MARK: TableView Delegate
extension SearchRestaurantVC: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//push view controller
		let venue = venues[indexPath.row]
		let image: UIImage!
		if photoForVenue[venue.id] != nil {
			image = photoForVenue[venue.id]
		} else {
			image = #imageLiteral(resourceName: "bg_wine1")
		}
//		let venueVC = VenueVC(school: selectedVenue)
//		navigationController?.pushViewController(venueVC, animated: true)
	}
}


extension SearchRestaurantVC: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		print("scrollViewDidScroll")
	}
}


extension SearchRestaurantVC: UIGestureRecognizerDelegate {
	func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		print("gestureRecognizerShouldBegin")
		print("tableview frame: \(tableView.frame)")
		if tableView.frame.origin.y <= 0.1 {
			return false
		}
		return true
	}
}
