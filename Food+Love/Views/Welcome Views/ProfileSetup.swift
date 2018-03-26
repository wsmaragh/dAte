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
	@IBOutlet weak var foodPref1: UITextField!
	@IBOutlet weak var foodPref2: UITextField!
	@IBOutlet weak var foodPref3: UITextField!
	@IBOutlet weak var restaurant1: UITextField!
	@IBOutlet weak var restaurant2: UITextField!
}

class AboutProfile: UIView {
	@IBOutlet weak var genderSC: UISegmentedControl!
	@IBOutlet weak var generPreferenceSC: UISegmentedControl!
	@IBOutlet weak var dateOfBirthPicker: UIDatePicker!
}

class HabitsProfile: UIView {
	@IBOutlet weak var drinkSC: UISegmentedControl!
	@IBOutlet weak var cigarettesSC: UISegmentedControl!
	@IBOutlet weak var weedSC: UISegmentedControl!
	@IBOutlet weak var drugsSC: UISegmentedControl!
	@IBOutlet weak var continueButton: UIButton!
}

class BioProfile: UIView {

}

class VideoProfile: UIView {

}



