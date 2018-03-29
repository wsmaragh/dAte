//
//  ProfileSetup.swift
//  Food+Love
//
//  Created by Winston Maragh on 3/25/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//


import Foundation
import UIKit


class PreferenceProfile: UIView {

	// MARK: Setup
	override init(frame: CGRect) {
		super.init(frame: UIScreen.main.bounds)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
	}
}

class AboutProfile: UIView {
	@IBOutlet weak var genderSC: UISegmentedControl!
	@IBOutlet weak var generPreferenceSC: UISegmentedControl!
	@IBOutlet weak var dateOfBirthPicker: UIDatePicker!
}


class BioProfile: UIView {
	@IBOutlet weak var boroughSC: UISegmentedControl!
	@IBOutlet weak var zipcodeTF: UITextField!
}

class VideoProfile: UIView {

	// MARK: Setup
	override init(frame: CGRect) {
		super.init(frame: UIScreen.main.bounds)
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
	}
}



