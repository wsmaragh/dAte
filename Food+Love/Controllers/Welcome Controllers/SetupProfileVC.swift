
//  FillOutProfileVC.swift
//  Food+Love
//  Created by C4Q on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.


import UIKit
import Firebase


class SetupProfileVC: UIViewController, UIScrollViewDelegate {

	@IBOutlet var preferenceSlide: UIView!
	@IBOutlet var aboutSlide: UIView!
	@IBOutlet var signupSlide: UIView!
	@IBOutlet weak var actionButton: UIButton!

	//Properties Fields
	@IBOutlet weak var favoriteFoodCategory1TF: UITextFieldX!
	@IBOutlet weak var favoriteFoodCategory2TF: UITextFieldX!
	@IBOutlet weak var favoriteFoodCategory3TF: UITextFieldX!
	@IBOutlet weak var favoriteRestaurant: UITextFieldX!
	@IBOutlet weak var genderSC: UISegmentedControl!
	@IBOutlet weak var genderPreferenceSC: UISegmentedControl!
	@IBOutlet weak var dobPicker: UIDatePicker!
	@IBOutlet weak var zipcodeTF: UITextField!
	@IBOutlet weak var firstNameTF: UITextFieldX!
	@IBOutlet weak var emailTF: UITextFieldX!
	@IBOutlet weak var passwordTF: UITextFieldX!
	@IBOutlet weak var profileImageButton: UIButton!
	@IBOutlet weak var addVideoButton: UIButton!


	@IBAction func addVideoPressed(_ sender: UIButton) {
		print("Add video pressed")
	}

	// MARK: Properties
	private var imagePicker = UIImagePickerController()
	var currentUser: User?
	private var profileSlides = [UIView]()
	private var slideIndex = 0


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		makeNavigationBarTransparent()
		imagePicker.delegate = self
		currentUser = Auth.auth().currentUser
		navigationController?.title = "Setup Profile"
		addShadeView()
		setupTextFields()
	}

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.view.alpha = 1.0
        //        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        self.view.alpha = 0.0
    }



	fileprivate func addShadeView(){
		let shade = UIView(frame: self.view.frame)
		shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
		view.addSubview(shade)
		view.sendSubview(toBack: shade)
	}
	
	// MARK: Helper Methods
	private func makeNavigationBarTransparent(){
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.tintColor = UIColor.white
		self.navigationController?.navigationBar.barTintColor = UIColor.white
		self.navigationController?.navigationBar.titleTextAttributes = [
			NSAttributedStringKey.foregroundColor : UIColor.white
		]
	}
	
	private func setupTextFields(){
		//Underline
		self.firstNameTF.underlined(color: .white)
		self.emailTF.underlined(color: .white)
		self.passwordTF.underlined(color: .white)

		//LeftViewMode
		self.firstNameTF.leftViewMode = .always
		self.emailTF.leftViewMode = .always
		self.passwordTF.leftViewMode = .always

		//Text Color
		firstNameTF.textColor = .white
		emailTF.textColor = .white
		passwordTF.textColor = .white
		
		//Placeholder Color
		if let firstNamePlaceholder = firstNameTF.placeholder {
			firstNameTF.attributedPlaceholder = NSAttributedString(string: firstNamePlaceholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightText])
		}
		if let emailPlaceholder = emailTF.placeholder {
			emailTF.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightText])
		}
		if let passwordPlaceholder = passwordTF.placeholder {
			passwordTF.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightText])
		}
	}


	// MARK: Action
	@IBAction func addVideoButton(_ sender: UIButton) {


	}


	@IBAction func nextPage(_ sender: UIButton) {
		switch slideIndex {
		case 0:
			preferenceSlide.isHidden = true
			aboutSlide.isHidden = false
			signupSlide.isHidden = true
		case 1:
			preferenceSlide.isHidden = true
			aboutSlide.isHidden = true
			signupSlide.isHidden = false
			actionButton.setTitle("Complete", for: .normal)
		case 2:
			if slideIndex == 2 && actionButton.title(for: .normal) == "Complete" {
				createNewAccount()
			}
		default:
			break
		}
		slideIndex += 1
	}


	@IBAction func addProfileImage(_ sender: UIButton) {
		let alertController = UIAlertController(title: "Add profile image", message: "", preferredStyle: UIAlertControllerStyle.alert)
		let existingPhotoAction = UIAlertAction(title: "Choose Existing Photo", style: .default) { (alertAction) in
			self.launchCamera(type: UIImagePickerControllerSourceType.photoLibrary)
		}
		let newPhotoAction = UIAlertAction(title: "Take New Photo", style: .default) { (alertAction) in
			self.launchCamera(type: UIImagePickerControllerSourceType.camera)
		}
		alertController.addAction(existingPhotoAction)
		alertController.addAction(newPhotoAction)
		present(alertController, animated: true, completion: nil)
	}

	
	@objc private func createNewAccount() {
		guard let name = self.firstNameTF.text, name != "" else {
			showAlert(title: "Please enter a name", message: ""); return
		}
		guard let email = self.emailTF.text, email != "" else {
			showAlert(title: "Please enter an email", message: ""); return
		}
		guard let password = self.passwordTF.text, password != "" else {
			showAlert(title: "Please enter a valid password", message: ""); return
		}
		if profileImageButton.image(for: UIControlState.normal) == #imageLiteral(resourceName: "selfieCamera") {
			showAlert(title: "Please add a profile image", message: ""); return
		}
		guard let image = self.profileImageButton.image(for: .normal) else {
			showAlert(title: "Please add a profile image", message: ""); return
		}
		if email.contains(" ") {
			showAlert(title: "No spaces allowed in email!", message: nil); return
		}
		if password.contains(" ") {
			showAlert(title: "No spaces allowed in password!", message: nil); return
		}
		AuthUserService.manager.createUser(name: name, email: email, password: password, profileImage: image)
		sleep(2)
		if let _ = Auth.auth().currentUser {
			completeProfile()
		}
	}

	func completeProfile(){
		//add user details to database
		guard let favCat1 = favoriteFoodCategory1TF.text else {return}
		guard let favCat2 = favoriteFoodCategory2TF.text else {return}
		guard let favCat3 = favoriteFoodCategory3TF.text else {return}
		guard let favRest = favoriteRestaurant.text else {return}
		guard let zipcode = 	zipcodeTF.text else {return}
		let gender = genderSC.selectedSegmentIndex == 0 ? "Male" : "Female"
		var genderPreference = "Female"
		switch genderPreferenceSC.selectedSegmentIndex {
			case 0: genderPreference = "Male"
			case 1: genderPreference = "Female"
			case 2: genderPreference = "Any"
			default: genderPreference = "Female"
		}

		let dobDate = dobPicker.date
		let dob = DBService.manager.formatDateforDOB(with: dobDate)
		print(favCat1)
		print(favCat2)
		print(favCat3)
		print(favRest)
		print(zipcode)
		print(gender)
		print(genderPreference)
		print(dob)

//		DBService.manager.addLoverDetails(favCat1: favCat1, favCat2: favCat2, favCat3: favCat3, favRestaurant: favRest, zipcode: zipcode, gender: gender, genderPreference: genderPreference, dateOfBirth: dob)
		print("user details added")
	}

	

//	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		let currentPage = scrollView.contentOffset.x / scrollView.frame.size.width
////		pageControl.currentPage = Int(currentPage)
//		slideIndex = pageControl.currentPage
//	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.favoriteFoodCategory1TF.resignFirstResponder()
		self.favoriteFoodCategory2TF.resignFirstResponder()
		self.favoriteFoodCategory3TF.resignFirstResponder()
		self.favoriteRestaurant.resignFirstResponder()
		self.zipcodeTF.resignFirstResponder()
		self.emailTF.resignFirstResponder()
		self.passwordTF.resignFirstResponder()
		self.firstNameTF.resignFirstResponder()
	}

	private func showAlert(title: String, message: String?) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}

	//Camera
	func launchCamera(type: UIImagePickerControllerSourceType){
		if UIImagePickerController.isSourceTypeAvailable(type){
			imagePicker.sourceType = type
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
	}
	

}


// MARK: TextField Delegate
extension SetupProfileVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		self.becomeFirstResponder()
		return true
	}
}


// MARK: Image Picker
extension SetupProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		var selectedImageFromPicker: UIImage?
		print("in image picker")
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			selectedImageFromPicker = editedImage
			print("Edited image selected from library/camera")
		}
		else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			selectedImageFromPicker = originalImage
			print("original image selected from library/camera")
		}
		if let selectedImage = selectedImageFromPicker {
			profileImageButton.setImage(selectedImage, for: .normal)
		}
		imagePicker.dismiss(animated: true, completion: nil)
	}

	//Cancel camera
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		imagePicker.dismiss(animated: true, completion: nil)
	}

}


