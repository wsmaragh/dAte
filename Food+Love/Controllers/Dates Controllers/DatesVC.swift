//
//  DateVC.swift
//  Food+Love
//
//
//

import UIKit
import FirebaseDatabase

class DatesVC: UIViewController {
    
    
    @IBOutlet weak var pendingTableView: UITableView!
    @IBOutlet weak var confirmedTableView: UITableView!
    
    
    var pendingDates = [PlanDate]() {
        didSet {
            print("Pending dates:",pendingDates.count)
            self.pendingTableView.reloadData()
        }
    }
    var confirmedDates = [PlanDate]() {
        didSet {
            print("Confirmed dates:",confirmedDates.count)
            self.confirmedTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pendingTableView.delegate = self
        confirmedTableView.delegate = self
        pendingTableView.dataSource = self
        confirmedTableView.dataSource = self
    
        loadData()
    }

    @IBAction func segmentedControl(_ sender: UISegmentedControl) {
        //confirmed
        
        if sender.selectedSegmentIndex == 0 {
            pendingTableView.isHidden = true
            confirmedTableView.isHidden = false
        }
        //pending
        else {
            confirmedTableView.isHidden = true
            pendingTableView.isHidden = false
        }
        confirmedTableView.reloadData()
        pendingTableView.reloadData()
        
    }
    
    private func loadData() {
        let ref = Database.database().reference().child("planDate")
        ref.observe(.value) { (snapshot) in
            var planDates = [PlanDate]()
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let planD = PlanDate(snapShot: snap)
                planDates.append(planD)
            }
            self.pendingDates = []
            self.confirmedDates = []
            self.pendingDates = planDates.filter{$0.confirmed == 0}
            self.confirmedDates = planDates.filter{$0.confirmed == 1}
        }
    }
    
}

// MARK:- TableView Delegates
extension DatesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.25
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if tableView == self.pendingTableView {
            let cancel = UITableViewRowAction(style: .destructive, title: "Cancel") { action, index in
                print("cancel button tapped")
                guard let refKey = self.pendingDates[indexPath.row].ref else {return}
                let ref = Database.database().reference().child("planDate").child(refKey)
                ref.removeValue()
                self.loadData()
            }
            cancel.backgroundColor = .lightGray
            
            let confirm = UITableViewRowAction(style: .normal, title: "Confirm") { action, index in
                print("confirm button tapped")
                guard let refKey = self.pendingDates[indexPath.row].ref else {return}
                let ref = Database.database().reference().child("planDate").child(refKey)
                ref.updateChildValues(["confirmed": 1])
                self.loadData()
            }
            confirm.backgroundColor = .orange
            
            return [confirm, cancel]
        } else {
            let cancel = UITableViewRowAction(style: .destructive, title: "Cancel") { action, index in
                print("cancel button tapped")
                guard let refKey = self.confirmedDates[indexPath.row].ref else {return}
                let ref = Database.database().reference().child("planDate").child(refKey)
                ref.removeValue()
                self.loadData()
            }
            cancel.backgroundColor = .lightGray
            
            return [cancel]
        }
    }
}

// MARK:- TableView Datasource
extension DatesVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberRecords = 0
        if tableView == self.pendingTableView {
            numberRecords = pendingDates.count
        } else {
            numberRecords = confirmedDates.count
        }
        return numberRecords
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.pendingTableView, let pendingCell = tableView.dequeueReusableCell(withIdentifier: "PendingDatesCell", for: indexPath) as? DatesCell {
            let planDate = pendingDates[indexPath.row]
            pendingCell.configureCell(planDate: planDate)
            return pendingCell
        } else if let confirmedCell = tableView.dequeueReusableCell(withIdentifier: "ConfirmedDatesCell", for: indexPath) as? DatesCell {
            let planDate = confirmedDates[indexPath.row]
            confirmedCell.configureCell(planDate: planDate)
            return confirmedCell
        }
        return UITableViewCell()
    }
    
    
}
