//  DiscoverVC.swift
//  Food+Love
//  Created by Gloria Washington on 3/21/18.
//  Copyright © 2018 Gloria Washington. All rights reserved.

import UIKit
import FirebaseAuth


class DiscoverVC: UIViewController {

	// MARK: View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(false)
		//Check if user is authenticated
		if Auth.auth().currentUser == nil {
			let welcomeVC = WelcomeVC()
			self.present(welcomeVC, animated: true, completion: nil)
		} 
	}

    



}
