
import UIKit
import FirebaseDatabase
import FirebaseAuth

enum MyTheme {
    case light
    case dark
}

class MakeDateVC: UIViewController {
    
    var theme = MyTheme.dark
    var selectRestaurantView = SelectRestaurantView()
    var searchRestview = SearchRestView()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Share", for: .normal)
        button.backgroundColor = Colors.blue
        button.layer.cornerRadius = button.frame.size.height / 2
        button.layer.borderColor = Colors.white.cgColor
        button.layer.borderWidth = 2
        button.showsTouchWhenHighlighted = true
        return button
    }()
    
    var fromUser: String?
    var toUser: String?
    var planDate: PlanDate? {
        didSet {
            self.selectRestaurantView.restaurantInfo.text = "\(planDate?.restaurant ?? "")"
            self.selectRestaurantView.addressInfo.text = "\(planDate?.address ?? "")"
            self.selectRestaurantView.hourInfo.text = "\(planDate?.hour ?? "")"
            self.selectRestaurantView.dateInfo.text = "\(planDate?.date ?? "")"
        }
    }
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.translatesAutoresizingMaskIntoConstraints = false
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blur
    }()
    
    lazy var pickerView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.black
        view.layer.opacity = 0.4
        view.layer.cornerRadius = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .time
        picker.setValue(UIColor.white, forKey: "textColor")
        return picker
    }()
    
    lazy var saveHourButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = Colors.blue
        button.setTitleColor(Colors.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderColor = Colors.white.cgColor
        button.layer.borderWidth = 2
        return button
    }()
    
    let calenderView: CalenderView = {
        let v = CalenderView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Plan date"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
			tabBarController?.tabBar.isHidden = true
        
        calenderView.delegate = self
        searchRestview.delegate = self
        
        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
        shareButton.addTarget(self, action: #selector(sharePlanDate), for: .touchUpInside)
        //let rightSignOutBtn = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(signOutApp))
        self.navigationItem.rightBarButtonItems = [rightBarBtn]
        self.selectRestaurantView.restaurantButton.addTarget(self, action: #selector(displayRestaurants), for: .touchUpInside)
        self.saveHourButton.addTarget(self, action: #selector(setupHour), for: .touchUpInside)
        setupViews()
        
        planDate = PlanDate(loverFrom: fromUser!, loverTo: toUser!, hour: "", date: "", dayId: "", monthId: "", yearId: "", monthStr: "", venueId: "", restaurant: "", address: "", confirmed: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        shareButton.layer.cornerRadius = shareButton.frame.size.height / 2
        shareButton.setNeedsLayout()
    }
    
    @objc private func sharePlanDate() {
        
        let ref = Database.database().reference().child("planDate")
        let newPlan = ref.childByAutoId()
        newPlan.setValue(planDate?.toAny()) { (error, dbRef) in
            if let error = error {
                print("Error while saving occurred:", error)
                return
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func signOutApp() {
        do {
            try Auth.auth().signOut()
            print("SignOut")
        } catch {
            print("Error signout:", error)
        }
    }
    
    @objc private func displayRestaurants() {
        searchRestview.isHidden = false
        blurEffectView.isHidden = false
        UIView.animate(withDuration: 1.3) {
            self.searchRestview.layer.opacity = 0.75
        }
    }
    
    @objc private func setupHour() {
        let date = datePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        planDate?.hour = "\(hour): \(minute)"
        UIView.animate(withDuration: 0.9) {
            self.pickerView.layer.opacity = 0.0
            self.searchRestview.layer.opacity = 0.75
        }
    }
    
    private func setupViews() {
        
        view.addSubview(calenderView)
        calenderView.translatesAutoresizingMaskIntoConstraints = false
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(selectRestaurantView)
        selectRestaurantView.translatesAutoresizingMaskIntoConstraints = false
        selectRestaurantView.topAnchor.constraint(equalTo: calenderView.bottomAnchor).isActive = true
        selectRestaurantView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        selectRestaurantView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        selectRestaurantView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        view.addSubview(shareButton)
        shareButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.30).isActive = true
        shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        
        //--- BlurView ---//
        view.addSubview(blurEffectView)
        blurEffectView.frame = view.bounds
        blurEffectView.layer.opacity = 0.0
        
        view.addSubview(searchRestview)
        searchRestview.translatesAutoresizingMaskIntoConstraints = false
        searchRestview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        searchRestview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        searchRestview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchRestview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        searchRestview.layer.opacity = 0.0
        
        view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        pickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        pickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        pickerView.layer.opacity = 0.0
        
        pickerView.addSubview(datePicker)
        datePicker.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor, constant: -32).isActive = true
        datePicker.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        datePicker.heightAnchor.constraint(equalTo: pickerView.heightAnchor, multiplier: 0.6).isActive = true
        
        pickerView.addSubview(saveHourButton)
        saveHourButton.bottomAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: -8).isActive = true
        saveHourButton.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor).isActive = true
        saveHourButton.widthAnchor.constraint(equalTo: pickerView.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
        saveHourButton.setNeedsLayout()
        selectRestaurantView.restaurantButton.setNeedsLayout()
    }
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
        if theme == .dark {
            sender.title = "Dark"
            theme = .light
            Style.themeLight()
        } else {
            sender.title = "Light"
            theme = .dark
            Style.themeDark()
        }
        self.view.backgroundColor=Style.bgColor
        calenderView.changeTheme()
    }
    
    
}

extension MakeDateVC: CalendarDelegate, SearchRestViewDelegate {
    func didSelectedItem(cell: CalenderView, day: String, month: String, year: String) {
        // show datepicker
        UIView.animate(withDuration: 0.33) {
            self.blurEffectView.layer.opacity = 1.0
            self.pickerView.layer.opacity = 1.0
        }
        
        // set labels
        let months = ["1": "January", "2": "February",
                      "3": "March", "4": "April",
                      "5": "May", "6": "June",
                      "7": "July", "8": "August",
                      "9": "September", "10": "Octuber",
                      "11": "November", "12": "December"]
        guard let monthLetters = months[month] else {return}
        planDate?.date = "\(monthLetters) \(day), \(year)"
        planDate?.yearId = year
        planDate?.monthId = month
        planDate?.monthStr = monthLetters
        planDate?.dayId = day
    }
    
    func didItemSelect(venueId: String, rest: String, address: String) {
        planDate?.restaurant = rest
        planDate?.venueId = venueId
        planDate?.address = address
        UIView.animate(withDuration: 0.33) {
            self.blurEffectView.layer.opacity = 0.0
            self.searchRestview.layer.opacity = 0.0
        }
    }
}

