
//  VideoVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/22/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVKit


class VideoVC: UIViewController {

	var lover: Lover?

	init(lover: Lover) {
		super.init(nibName: nil, bundle: nil)
		self.lover = lover
	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tabBarController?.tabBar.isHidden = true
		view.backgroundColor = UIColor.orange
//		navigationItem.title = lover?.name
	}



}
