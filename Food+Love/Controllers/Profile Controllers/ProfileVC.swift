//
//  ProfileVC.swift
//  Food+Love
//
//
//


import UIKit
import Firebase
import ImageIO
import Eureka


class ProfileVC: UIViewController {
    
    // MARK: Action Buttons
    //    @IBOutlet weak var logoutButton: UIBarButtonItem!
    //    @IBOutlet weak var settingsButton: UINavigationItem!
    @IBOutlet weak var userPictureCollectionView: UICollectionView!
    @IBOutlet weak var otherSettingsTableView: UITableView!
    fileprivate var editProfileController: EditProfileFormViewController?
    
    var otherUserSettingsTitles = ["Terms & Conditions", "Delete Account", "Rate Us", "About Us" ]
    
    
    
    // MARK: Properties
    private var currentAuthUser = Auth.auth().currentUser
    
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBar()
        setUpEditProfileContainer()
        setUpUserPictureCollectionView()
        setUpOtherSettingsTableView()
        
        
    }
    
    // MARK: Properties
    
    
    private func setUpEditProfileContainer() {
        guard let editProfile = childViewControllers.first as? EditProfileFormViewController else  {
            fatalError("Check storyboard for missing EditProfileFormViewContrller")
        }
        editProfileController  = editProfile
    }
    
    // Actions
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        let alertView = UIAlertController(title: "Are you sure you want to Logout?", message: nil, preferredStyle: .alert)
        let yesOption = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
            self.logout()
        }
        let noOption = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertView.addAction(yesOption)
        alertView.addAction(noOption)
        present(alertView, animated: true, completion: nil)
    }
    
    //logout
    func logout(){
        do {
            try Auth.auth().signOut()
            let welcomeVC = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "WelcomeController")
            if let window = UIApplication.shared.delegate?.window {
                window?.rootViewController = welcomeVC
            }
        }
        catch { print("Error signing out: \(error)") }
    }
    
    
    private func setUpUserPictureCollectionView() {
        userPictureCollectionView.dataSource = self
    }
    
    private func setUpOtherSettingsTableView() {
        otherSettingsTableView.dataSource = self
    }
    
    
    //MARK: Helper Functions
    private func configureNavBar() {
        self.navigationItem.title = "Profile"
        let uploadButton = UIBarButtonItem(title: "Upload", style: .plain, target: self, action: #selector(uploadButtonClicked))
        self.navigationItem.leftBarButtonItem = uploadButton
        let logOutButton = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logoutPressed(_:)))
        self.navigationItem.rightBarButtonItem  = logOutButton
    }
    
    
    
    
    
    @objc private func uploadButtonClicked() {
        //Add alert sheet for pictures here
        let alertSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let openCamera = UIAlertAction.init(title: "Take Photo", style: .default) { [weak self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera;
                imagePicker.allowsEditing = false
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        let openGallery = UIAlertAction(title: "Upload from Photo Library", style: .default) { [weak self] (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = false
                self?.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        alertSheet.addAction(openCamera)
        alertSheet.addAction(openGallery)
        alertSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil) )
        self.present(alertSheet, animated: true, completion: nil)
        
    }
    
}


extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
    }
}


extension ProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userPictureCollectionView.dequeueReusableCell(withReuseIdentifier: "UserPictureCell", for: indexPath) as! UserPicturesCollectionViewCell
        return cell
    }
    
    
}

extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherUserSettingsTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = otherSettingsTableView.dequeueReusableCell(withIdentifier: "OtherSettingCell", for: indexPath)
        let cellTitle = otherUserSettingsTitles[indexPath.row]
        cell.textLabel?.text = cellTitle
        return cell

    }

}


