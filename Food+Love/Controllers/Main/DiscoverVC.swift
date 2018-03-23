//
//  DiscoverVC.swift
//  Food+Love
//  Created by Gloria Washington on 3/21/18.
//  Copyright © 2018 Gloria Washington. All rights reserved.
//

import UIKit
import Firebase

class DiscoverVC: UIViewController {

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		if Auth.auth().currentUser == nil {
			let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeController")
			if let window = UIApplication.shared.delegate?.window {
				window?.rootViewController = welcomeVC
			}
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}





}
