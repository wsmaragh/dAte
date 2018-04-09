//
//  DateVC.swift
//  Food+Love
//
//
//

import UIKit
import FirebaseDatabase


class DatesVC: UIViewController {
    
    let indetifier1 = "Cell1"
    let indetifier2 = "cell2"
    var currentLover: Lover?
    
    @IBOutlet weak var pendingTableView: UITableView!
    @IBOutlet weak var confirmedTableView: UITableView!
    var indexPathSelectedRow: IndexPath?
    
    var pendingDates = [PlanDate]() {
        didSet {
            //print("Pending dates:",pendingDates.count)
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
        pendingTableView.register(DatesCell.self, forCellReuseIdentifier: indetifier1)
        pendingTableView.register(DatesCellColapsed.self, forCellReuseIdentifier: indetifier2)
        pendingTableView.delegate = self
        confirmedTableView.delegate = self
        pendingTableView.dataSource = self
        confirmedTableView.dataSource = self
        DBService.manager.getCurrentLover(completionHandler: { (lover, error) in
            if let error = error {
                print("No user:",error)
                return
            }
            if let lover = lover {
                self.currentLover = lover
            }
        })
        loadData()
				setupNavBar()
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

	private func setupNavBar(){
		let image : UIImage = #imageLiteral(resourceName: "Logo3")
		let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
		imageView.contentMode = .scaleAspectFit
		imageView.image = image
		self.navigationItem.titleView = imageView
	}

    func confirmMessage(title: String, message: String) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        message.addAction(okAction)
        present(message, animated: true, completion: nil)
    }
    
}

// MARK:- TableView Delegates
extension DatesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousSelection = self.indexPathSelectedRow
        
        if self.indexPathSelectedRow == indexPath {
            self.indexPathSelectedRow = nil
        } else {
            self.indexPathSelectedRow = indexPath
        }
        
        let reloadlist = [indexPath, previousSelection].flatMap({$0})
        
        tableView.reloadRows(at: reloadlist, with: UITableViewRowAnimation.automatic)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.indexPathSelectedRow == nil {
            return view.frame.size.height * 0.25
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cancel = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .destructive, title: "Cancel", handler: { (action, view, isConfirmed) in
            if tableView == self.pendingTableView {
                let message = UIAlertController(title: "Cancel Date", message: "Are you sure you want to cancel this date?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
                    if action.isEnabled {
                        guard let refKey = self.pendingDates[indexPath.row].ref else {return}
                        let ref = Database.database().reference().child("planDate").child(refKey)
                        ref.removeValue()
                    }
                })
                let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
                message.addAction(okAction)
                message.addAction(cancelAction)
                self.present(message, animated: true, completion: nil)
            } else {
                let message = UIAlertController(title: "Cancel Date", message: "Are you sure you want to cancel this date?", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
                    if action.isEnabled {
                        guard let refKey = self.confirmedDates[indexPath.row].ref else {return}
                        let ref = Database.database().reference().child("planDate").child(refKey)
                        ref.removeValue()
                    }
                })
                let cancelAction = UIAlertAction(title: "No", style: .default, handler: nil)
                message.addAction(okAction)
                message.addAction(cancelAction)
                self.present(message, animated: true, completion: nil)
            }
            self.loadData()
            //print("Cancel button tapped")
        })])
        return cancel
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let confirm = UISwipeActionsConfiguration(actions: [UIContextualAction(style: .normal, title: "Confirm", handler: { (action, view, isConfirmed) in
            //print("Confirm button tapped")
            if tableView == self.pendingTableView {
                //var loverFrom = ""
                guard let refKey = self.pendingDates[indexPath.row].ref else {return}
                let ref = Database.database().reference().child("planDate").child(refKey)
                ref.child("loverFrom").observe(.value, with: { (snapshot) in
                    if let value = snapshot.value as? String {
                        if self.currentLover?.id != value {
                            ref.updateChildValues(["confirmed": 1])
                            self.confirmMessage(title: "Date Confirmed", message: "Your date has been confirmed.")
                        } else {
                            self.confirmMessage(title: "Wait for response", message: "You can't confirm this Date, please wait for the confirmation of your Lover.")
                        }
                    }
                })
                
            } else {
                guard let refKey = self.confirmedDates[indexPath.row].ref else {return}
                let ref = Database.database().reference().child("planDate").child(refKey)
                ref.updateChildValues(["confirmed": 1])
                self.confirmMessage(title: "Date Confirmed", message: "Your date has been confirmed.")
            }
            self.loadData()
        })])
        return confirm
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
        if tableView == self.pendingTableView {
            if self.indexPathSelectedRow == indexPath {
                if let pendingCell = tableView.dequeueReusableCell(withIdentifier: self.indetifier2, for: indexPath) as? DatesCellColapsed {
                    let planDate = pendingDates[indexPath.row]
                    pendingCell.configureCell(planDate: planDate)
                    pendingCell.setNeedsLayout()
                    return pendingCell
                }
            } else {
                if let pendingCell = tableView.dequeueReusableCell(withIdentifier: self.indetifier1, for: indexPath) as? DatesCell {
                    let planDate = pendingDates[indexPath.row]
                    pendingCell.configureCell(planDate: planDate)
                    pendingCell.setNeedsLayout()
                    return pendingCell
                }
            }
        } else if let confirmedCell = tableView.dequeueReusableCell(withIdentifier: "ConfirmedDatesCell", for: indexPath) as? DatesCell {
            let planDate = confirmedDates[indexPath.row]
            confirmedCell.configureCell(planDate: planDate)
            confirmedCell.setNeedsLayout()
            return confirmedCell
        }
        return UITableViewCell()
    }
    
    
}
