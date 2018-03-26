//
//  EditProfileFormViewController.swift
//  Food+Love
//
//  Created by C4Q on 3/24/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
//

import UIKit
import Eureka
class EditProfileFormViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        animateScroll = true
        // Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
        rowKeyboardSpacing = 20
       
        form +++ Section()
            <<< TextRow(){ row in
                row.title = "Name"
        }
            <<< DateRow(){
                $0.title = "Birthdate"
                $0.value = Date()
        }
            <<< ZipCodeRow(){ row in
                row.title = "ZipCode"
        }
        
            +++ Section("Other Users")
        let userLikesSmokersCell  = CheckRow("Smoker") { check in
            check.title = "Smokes"
            check.value = true
            }.onChange { check in
                let smokes: Bool?
                check.value == true ? (smokes = true) :  (smokes = false)
        }
   
        
        let userLikesDrinkersCell  =  CheckRow("Drinker") { check in
            check.title = "Drinks"
            check.value = true
            }.onChange { check in
                let drink: Bool?
                check.value == true ? (drink = true) :  (drink = false)
        }
       
        
        let userOkayWithDrugUsers  = CheckRow("Druggie") { check in
            check.title = "Uses Drugs"
            check.value = true
            }.onChange { check in
                let drug: Bool?
                check.value == true ? (drug = true) :  (drug = false)
        }
        let userOkayWithParents  = CheckRow("HasChildren") { check in
            check.title = "Has Children"
            check.value = true
            }.onChange { check in
                let drug: Bool?
                check.value == true ? (drug = true) :  (drug = false)
        }
        
        
        form +++ userLikesSmokersCell +++ userLikesDrinkersCell +++ userOkayWithDrugUsers +++ userOkayWithParents
        
        
        +++ Section("You")
         let userSmokes =  CheckRow("Smokes") { check in
            check.title = "Smoke"
            check.value = true
            }.onChange { check in
                let smokes: Bool?
                check.value == true ? (smokes = true) :  (smokes = false)
        }
        let userDrinks =   CheckRow("Drink") { check in
            check.title = "Drink"
            check.value = true
            }.onChange { check in
                let drink: Bool?
                check.value == true ? (drink = true) :  (drink = false)
        }
        let userDrugs  =   CheckRow("Drugs") { check in
            check.title = "Use Drugs"
            check.value = true
            }.onChange { check in
                let drug: Bool?
                check.value == true ? (drug = true) :  (drug = false)
        }
        let userIsParent  =   CheckRow("Parent") { check in
            check.title = "Have Children"
            check.value = true
            }.onChange { check in
                let drug: Bool?
                check.value == true ? (drug = true) :  (drug = false)
        }
        
        form +++ userSmokes +++ userDrinks +++ userDrugs +++ userIsParent


        +++ Section("About You")
            <<< TextRow(){ row in
                row.title = "Favorite Restaurant:"
            }

            <<< TextRow(){ row in
                row.title = "I Am:"
        }
            <<< TextRow(){ row in
                row.title = "I'm looking for:"
        }

        tableView.layoutIfNeeded()
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
