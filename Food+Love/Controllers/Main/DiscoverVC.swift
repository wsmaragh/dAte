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
			let welcomeVC = WelcomeVC()
			self.present(welcomeVC, animated: true, completion: nil)
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}





}
