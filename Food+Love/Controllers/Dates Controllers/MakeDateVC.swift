
import UIKit
import FirebaseAuth
import FirebaseInstanceID
import FirebaseMessaging

enum MyTheme {
    case light
    case dark
}

class MakeDateVC: UIViewController {
    
    var theme = MyTheme.dark
    var selectRestaurantView = SelectRestaurantView()
    var searchRestview = SearchRestView()
    
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
    
    var hourDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Plan date"
        self.navigationController?.navigationBar.isTranslucent=false
        self.view.backgroundColor=Style.bgColor
        
        calenderView.delegate = self
        searchRestview.delegate = self
        
        let rightBarBtn = UIBarButtonItem(title: "Light", style: .plain, target: self, action: #selector(rightBarBtnAction))
        //let rightSignOutBtn = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(signOutApp))
        self.navigationItem.rightBarButtonItems = [rightBarBtn]
        self.selectRestaurantView.restaurantButton.addTarget(self, action: #selector(displayRestaurants), for: .touchUpInside)
        self.saveHourButton.addTarget(self, action: #selector(setupHour), for: .touchUpInside)
        setupViews()
        sendMessagingFCM()
    }
    
    private func sendMessagingFCM() {
        Messaging.messaging().sendMessage(["body" : "great match!",
                                           "title" : "Portugal vs. Denmark"],
                                          to: "cBY7Bsw5Ktk:APA91bFtNkbAonfDlanh4YA0A9p3y5LZCkFOQ5FCES14pMineg-T6tOdXH44Lc_3t7tQzisTfVIZJxYdk9KOhbbUMeSbnkcqrpBrQwJ9iIu3XArs3tYYr3uFPHOyEtqZ7vYxCCsbKSq_", withMessageID: "qwerty-5", timeToLive: 1000)
        print("---- Message sent -----")
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
        UIView.animate(withDuration: 1.3) {
            self.searchRestview.layer.opacity = 0.75
        }
    }
    
    @objc private func setupHour() {
        let date = datePicker.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour!
        let minute = components.minute!
        self.selectRestaurantView.hourInfo.text = "\(hour): \(minute)"
        UIView.animate(withDuration: 0.2) {
            self.pickerView.layer.opacity = 0.0
        }
    }
    
    private func setupViews() {
        view.addSubview(selectRestaurantView)
        selectRestaurantView.translatesAutoresizingMaskIntoConstraints = false
        selectRestaurantView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        selectRestaurantView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        selectRestaurantView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        selectRestaurantView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        
        
        view.addSubview(calenderView)
        calenderView.translatesAutoresizingMaskIntoConstraints = false
        calenderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        calenderView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(searchRestview)
        searchRestview.translatesAutoresizingMaskIntoConstraints = false
        searchRestview.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        searchRestview.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        searchRestview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        searchRestview.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        searchRestview.isHidden = true
        
        view.addSubview(pickerView)
        pickerView.centerXAnchor.constraint(equalTo: calenderView.centerXAnchor).isActive = true
        pickerView.centerYAnchor.constraint(equalTo: calenderView.centerYAnchor).isActive = true
        pickerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        pickerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        
        pickerView.isHidden = true
        pickerView.layer.opacity = 0.0
        
        pickerView.addSubview(datePicker)
        datePicker.centerXAnchor.constraint(equalTo: pickerView.centerXAnchor).isActive = true
        datePicker.centerYAnchor.constraint(equalTo: pickerView.centerYAnchor).isActive = true
        datePicker.widthAnchor.constraint(equalTo: pickerView.widthAnchor, multiplier: 0.8).isActive = true
        datePicker.heightAnchor.constraint(equalTo: pickerView.heightAnchor, multiplier: 0.33).isActive = true
        
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
    
    let calenderView: CalenderView = {
        let v = CalenderView(theme: MyTheme.dark)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
}

extension MakeDateVC: CalendarDelegate, SearchRestViewDelegate {
    func didSelectedItem(cell: CalenderView, day: String, month: String, year: String) {
        // show datepicker
        pickerView.isHidden = false
        UIView.animate(withDuration: 0.33) {
            self.pickerView.layer.opacity = 0.7
        }
        
        // set labels
        let months = ["1": "January", "2": "February",
                      "3": "March", "4": "April",
                      "5": "May", "6": "June",
                      "7": "July", "8": "August",
                      "9": "September", "10": "Octuber",
                      "11": "November", "12": "December"]
        guard let monthLetters = months[month] else {return}
        selectRestaurantView.dateInfo.text = "\(monthLetters) \(day), \(year)"
    }
    
    func didItemSelect(rest: String, addres: String) {
        self.selectRestaurantView.restaurantInfo.text = "\(rest)"
        self.selectRestaurantView.addressInfo.text = "\(addres)"
        self.searchRestview.isHidden = true
        self.searchRestview.layer.opacity = 0.0
        
    }
}

