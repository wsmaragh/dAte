
//  LocationServices.swift
//  Food+Love
//  Created by Winston Maragh on 3/14/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Foundation
import CoreLocation
import UIKit
import MapKit

class LocationService: NSObject {

	// MARK: View Lifecycle
	private override init() {
		super.init() //whenever you override you should call super
		locationManager = CLLocationManager()
		locationManager.delegate = self
	}
	static let manager = LocationService()
	private var locationManager: CLLocationManager!
}


// MARK: Custom functions
extension LocationService {
	public func checkForLocationServices() -> CLAuthorizationStatus {
		var status: CLAuthorizationStatus!
		var count: Int = 0

		//check if location services is enabled
		if CLLocationManager.locationServicesEnabled() {
			print("location services available")
			switch CLLocationManager.authorizationStatus() {
			case .notDetermined:
				locationManager.requestWhenInUseAuthorization()
				status = CLAuthorizationStatus.notDetermined
			case .denied:
				status = CLAuthorizationStatus.denied
				if count == 0 {
					//Alert to user
					let alertController = UIAlertController(title: "Location services needed", message: nil, preferredStyle: UIAlertControllerStyle.alert)
					let dontAction = UIAlertAction(title: "Dont Allow", style: .default, handler: nil)
					let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { (alertAction) in
						//opens phone Settings so user can authorize permission
						guard let validSettingsURL: URL = URL(string: UIApplicationOpenSettingsURLString) else {return}
						UIApplication.shared.open(validSettingsURL, options: [:], completionHandler: nil)
						count += 1
					})
					alertController.addAction(dontAction)
					alertController.addAction(allowAction)
					//present(alertController, animated: true, completion: nil)
				}
			case .authorizedWhenInUse:
				status = CLAuthorizationStatus.authorizedWhenInUse
			case .authorizedAlways:
				status = CLAuthorizationStatus.authorizedAlways
			case .restricted:
				status = CLAuthorizationStatus.restricted
				if count == 0 {
					//Alert to user
					let alertController = UIAlertController(title: "Location services needed", message: nil, preferredStyle: UIAlertControllerStyle.alert)
					let dontAction = UIAlertAction(title: "Dont Allow", style: .default, handler: nil)
					let allowAction = UIAlertAction(title: "Allow", style: .default, handler: { (alertAction) in
						//opens phone Settings so user can authorize permission
						guard let validSettingsURL: URL = URL(string: UIApplicationOpenSettingsURLString) else {return}
						UIApplication.shared.open(validSettingsURL, options: [:], completionHandler: nil)
						count += 1
					})
				}
			}
		}
			//Update UI to inform user
		else {
			print("location services NOT available.")
		}
		return status
	}
}



//MARK: CLLocationManager Delegate
extension LocationService: CLLocationManagerDelegate {

	func determineMyLocation() {
		locationManager = CLLocationManager() //create instance of locationManager
		locationManager.delegate = self //set delegate to SearchViewController
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestAlwaysAuthorization()

		//if user opted in for location services, start updating
		if CLLocationManager.locationServicesEnabled() {
			locationManager.startUpdatingLocation()
		}
	}


	//Did update Location
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { print("no locations"); return }
		//		guard let location = locations.first else { print("no locations"); return }
		//		let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
		//		let region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpan(latitudeDelta: 0.045, longitudeDelta: 0.045))
		//		searchView.searchMap.setRegion(region, animated: true)
		//		searchView.searchMap.showsUserLocation = true
		//        locationManager.stopUpdatingLocation()
	}

	//did update Location
	func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
		//		let region = MKCoordinateRegionMakeWithDistance(newLocation.coordinate, 100, 100)
		//		searchView.searchMap.setRegion(region, animated: true)
		//		searchView.searchMap.showsUserLocation = true
	}

	//Fail with error
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("did fail with error: \(error)")
	}

	//Did Change Authorization
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		print("did change Authorization: \(status)") //eg. denied
	}

}






