//
//  EditProfileFormViewController.swift
//  Food+Love
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import Eureka
import Firebase
enum Gender: String {
    case Male
    case Female
}
class EditProfileFormViewController: FormViewController {
     var categories = [String]()
    var currentLover: Lover? {
        didSet {
            guard currentLover != nil else {return}
           self.updateFormsRowValue()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        animateScroll = true
        self.setUpForms()
        loadCurrentUserProfile()
        DBService.manager.getCategories { (onlineCat) in
            self.categories = onlineCat
        }
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 10
        tableView.layoutIfNeeded()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    func loadCurrentUserProfile() {
        DBService.manager.getCurrentLover { (onlineLover, error) in
            if let lover = onlineLover {
                self.currentLover = lover
            }
            if let error = error {
                print("loading current user error: \(error)")
            }
        }
    }
    func updateFormsRowValue() {
        let nameRow = self.form.rowBy(tag: "name") as! TextRow
        nameRow.value = self.currentLover!.name
        nameRow.reload()
        
        let genderRow = self.form.rowBy(tag: "gender") as! PickerInlineRow<String>
          genderRow.value = self.currentLover!.gender
        genderRow.reload()
        
        let genderPreferenceRow = self.form.rowBy(tag: "genderPreference") as! PickerInlineRow<String>
        genderPreferenceRow.value = self.currentLover!.genderPreference
        genderPreferenceRow.reload()
        
        let dobRow = self.form.rowBy(tag: "dateOfBirth") as! DateRow
        let dateStr = self.currentLover!.dateOfBirth
        guard dateStr != nil else {
            let date = Date()
            dobRow.value = date
            return
        }
        let date = self.changeStringToDate(dateString: dateStr!) ?? Date()
        dobRow.value = date
        dobRow.reload()
     
        let zipcodeRow = self.form.rowBy(tag: "zipcode") as! ZipCodeRow
         zipcodeRow.value = self.currentLover!.zipcode
        zipcodeRow.reload()
        
        let firstFoodPreferRow = self.form.rowBy(tag: "firstFoodPrefer") as! PickerInlineRow<String>
        firstFoodPreferRow.value = self.currentLover!.firstFoodPrefer
        firstFoodPreferRow.reload()
        
        let secondFoodPreferRow = self.form.rowBy(tag: "secondFoodPrefer") as! PickerInlineRow<String>
        secondFoodPreferRow.value = self.currentLover!.secondFoodPrefer
        secondFoodPreferRow.reload()
        
        let thirdFoodPreferRow = self.form.rowBy(tag: "thirdFoodPrefer") as! PickerInlineRow<String>
        thirdFoodPreferRow.value = self.currentLover!.thirdFoodPrefer
        thirdFoodPreferRow.reload()
        
        let favDishRow = self.form.rowBy(tag: "favDish") as! TextRow
        favDishRow.value = self.currentLover!.favDish
        favDishRow.reload()
        
        let bioRow = self.form.rowBy(tag: "bio") as! TextRow
        bioRow.value =  self.currentLover!.bio
        bioRow.reload()
    }
    func setUpForms() {
        form +++ Section()
            <<< TextRow(){ row in
                row.tag = "name"
                row.title = "Name"
                }
            <<< PickerInlineRow<String>() {
                $0.tag = "gender"
                $0.title = "Gender"
                }.cellUpdate({ (cell, row) in
                    row.options = ["Male", "Female"]
                })
            <<< PickerInlineRow<String>() {
                $0.tag = "genderPreference"
                $0.title = "Gender Preference"
                }.cellUpdate({ (cell, row) in
                    row.options = ["Male", "Female"]
                })
            <<< DateRow(){
                $0.tag = "dateOfBirth"
                $0.title = "Date of birth"
               // $0.value = Date()
                $0.maximumDate = Date()
                }
            <<< ZipCodeRow(){ row in
                row.tag = "zipcode"
                row.title = "ZipCode"
                }
            
            +++ Section("Food Preferences")
            <<< PickerInlineRow<String>() {
                $0.tag = "firstFoodPrefer"
                $0.title = "Option 1"
                }.cellUpdate({ (cell, row) in
                    row.options = self.categories
                    
                })
            <<< PickerInlineRow<String>() {
                $0.tag = "secondFoodPrefer"
                $0.title = "Option 2"
                }.cellUpdate({ (cell, row) in
                    row.options = self.categories
                })
            <<< PickerInlineRow<String>() {
                $0.tag = "thirdFoodPrefer"
                $0.title = "Option 3"
                }.cellUpdate({ (cell, row) in
                    row.options = self.categories
                })
            
            
            //            +++ Section("Other Users")
            //        let userLikesSmokersCell  = CheckRow("Smoker") { check in
            //            check.title = "Smokes"
            //            check.value = true
            //            }.onChange { check in
            //                let smokes: Bool?
            //                check.value == true ? (smokes = true) :  (smokes = false)
            //        }
            
            //  form +++ userLikesSmokersCell +++ userLikesDrinkersCell
            
            
            
            
            +++ Section("About You")
            <<< TextRow(){ row in
                row.tag = "favDish"
                row.title = "Favorite dish"
                }
            
            <<< TextRow(){ row in
                row.tag = "bio"
                row.title = "Bio"
                }
    }
    func getValuesInRows() -> [String: Any?] {
        let valuesDictionary = form.values()
        print(valuesDictionary)
        return valuesDictionary
    }
    func changeStringToDate(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        return date
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
