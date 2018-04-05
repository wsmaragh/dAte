
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
import AVFoundation
import Toucan

class ProfileVC: UIViewController {
    
    // MARK: Action Buttons
    //    @IBOutlet weak var logoutButton: UIBarButtonItem!
    //    @IBOutlet weak var settingsButton: UINavigationItem!
    @IBOutlet weak var userPictureCollectionView: UICollectionView!
    @IBOutlet weak var otherSettingsTableView: UITableView!
    fileprivate var editProfileController: EditProfileFormViewController?
    
    private var imagePickerViewController = UIImagePickerController()
    private var currentSelectedIndex: Int!
    private var profileImages: [UIImage] = [#imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "profile")] {
        didSet {
            DispatchQueue.main.async {
                self.userPictureCollectionView.reloadData()
            }
        }
    }
   
    var otherUserSettingsTitles = ["Terms & Conditions", "Delete Account", "Rate Us", "About Us" ]
    
    
    
    // MARK: Properties
    private var currentAuthUser = Auth.auth().currentUser
//    var userImageUrls = [String]() {
//        didSet {
//            self.userPictureCollectionView.reloadData()
//        }
//    }
    var currentLover: Lover? {
        didSet {
            loadImages()
//           userImageUrls = [currentLover!.profileImageUrl0 ?? "", currentLover!.profileImageUrl1 ?? "", currentLover!.profileImageUrl2 ?? "" ]
        }


    }
    func loadImages() {

        guard self.currentLover != nil else {return}
        let url0 = currentLover!.profileImageUrl ?? ""
        let url1 = currentLover!.profileImageUrl1 ?? ""
        let url2 = currentLover!.profileImageUrl2 ?? ""
      
        ImageHelper.manager.getImage(from: url0, completionHandler: {
          self.profileImages[0] = $0
        }, errorHandler: {_ in })
        ImageHelper.manager.getImage(from: url1, completionHandler: {
            self.profileImages[1] = $0
        }, errorHandler: {_ in })
        ImageHelper.manager.getImage(from: url2, completionHandler: {
             self.profileImages[2] = $0
        }, errorHandler: {_ in })
       // self.profileImages = [image1, image2, image3]

//        guard self.currentLover != nil else {return}
 //       let url0 = currentLover!.profileImageUrl ?? ""
//        let url1 = currentLover!.profileImageUrl1 ?? ""
//        let url2 = currentLover!.profileImageUrl2 ?? ""
  //      ImageHelper.manager.getImage(from: url0, completionHandler: {
 //         self.profileImages[0] = $0
  //      }, errorHandler: {_ in })
//        ImageHelper.manager.getImage(from: url1, completionHandler: {
//             self.profileImages[1] = $0
//        }, errorHandler: {_ in })
//        ImageHelper.manager.getImage(from: url2, completionHandler: {
//             self.profileImages[2] = $0
//        }, errorHandler: {_ in })

        }
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userPictureCollectionView.delegate = self
        self.userPictureCollectionView.dataSource = self
        self.imagePickerViewController.delegate = self
        configureNavBar()
        setUpEditProfileContainer()
        loadCurrentUser()
        self.currentLover = editProfileController?.currentLover
        setUpUserPictureCollectionView()
        setUpOtherSettingsTableView()
    }
    
    // MARK: Properties
    func loadCurrentUser() {
        DBService.manager.getCurrentLover { (onlineLover, error) in
            if let lover = onlineLover {
                self.currentLover = lover
            }
            if let error = error {
                print("loading current user error: \(error)")
            }
        }
    }
    
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
        uploadImagesToStorage()
        updateCurrentUserProfile()
  }
    // upload user images to storage and update imageUrls to database
    func uploadImagesToStorage() {
        guard let uid = self.currentAuthUser?.uid else {return}
        for (index,image) in self.profileImages.enumerated() {
            StorageService.manager.storeProfileImage(image: image, userId: uid, imageIndex: index)
        }
    }
    // update user profile infomations to database
    func updateCurrentUserProfile() {
        guard let editVC = self.editProfileController else {return}
        var editedDict = editVC.getValuesInRows()
        if let date = editedDict["dateOfBirth"] as? Date {
        let dateString = formatDate(with: date)
         editedDict["dateOfBirth"] = dateString
        }
        
       DBService.manager.updateEditedProfileInfo(ediedDict: editedDict)
    }
    
    public func formatDate(with date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-d"
        return dateFormatter.string(from: date)
    }

}


extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "User Camera", style: .default) { [weak self](action) in
            self?.imagePickerViewController.sourceType = .camera
            self?.checkAVAuthoriation()
        }
        
        let album = UIAlertAction(title: "Choose from Album", style: .default) { [weak self](action) in
            self?.imagePickerViewController.sourceType = .photoLibrary
            self?.checkAVAuthoriation()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(camera)
        }
        alert.addAction(camera)
        alert.addAction(album)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    private func checkAVAuthoriation() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
            print("notDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    self.showPhotoLibrary()
                } else {
                    print("not granted")
                }
            })
        case .denied:
            print("denied")
        case .restricted:
            print("restricted")
        case .authorized:
            print("authorized")
            self.showPhotoLibrary()
        }
    }
    
    func showPhotoLibrary() {
        present(imagePickerViewController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("image is nil")
            return
        }
        // resize the image using Toucan
        let imageSize = CGSize(width: 200, height: 200)
        let toucanImage = Toucan.Resize.resizeImage(image, size: imageSize)
        profileImages[currentSelectedIndex] = toucanImage!
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension ProfileVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = userPictureCollectionView.dequeueReusableCell(withReuseIdentifier: "UserPictureCell", for: indexPath) as! UserPicturesCollectionViewCell
        let image = self.profileImages[indexPath.row]
        cell.userPictureImageView.image = image
        return cell
    }
    
    
}
extension ProfileVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentSelectedIndex = indexPath.row
        showActionSheet()
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


