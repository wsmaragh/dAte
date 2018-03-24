
//  SignupVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation
import Firebase
import ImageIO


class SignupVC: UIViewController {

	@IBOutlet weak var profileImageButton: UIButton!
	@IBOutlet weak var firstNameTF: UITextField!
	@IBOutlet weak var emailTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!


	var messagesController: MatchesVC?
	var profileImageView: UIImageView!
	private var authUserService = AuthUserService()
	let imagePicker = UIImagePickerController()
	private var newUserImage: UIImage!




	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		imagePicker.delegate = self
		self.firstNameTF.underlined(color: .white)
		self.emailTF.underlined(color: .white)
		self.passwordTF.underlined(color: .white)
		makeNavigationBarTransparent()
		setPlaceholderTextColor(color: UIColor.lightText)
		addShadeView()
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(false)
		self.view.alpha = 0.0
	}


	// MARK: Actions
	@IBAction func addProfilePressed(_ sender: UIButton) {
		addProfileImage()
	}


	@IBAction func register(_ sender: UIButtonX) {
		createNewAccount()

	}


	fileprivate func addShadeView(){
		let shade = UIView(frame: self.view.frame)
		shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
		view.addSubview(shade)
		view.sendSubview(toBack: shade)
	}


	fileprivate func makeNavigationBarTransparent(){
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.tintColor = UIColor.white
		self.navigationController?.navigationBar.barTintColor = UIColor.white
		self.navigationController?.navigationBar.titleTextAttributes = [
			NSAttributedStringKey.foregroundColor : UIColor.white
		]
	}

	fileprivate func setPlaceholderTextColor(color: UIColor){
		if let firstNamePlaceholder = firstNameTF.placeholder {
			firstNameTF.attributedPlaceholder = NSAttributedString(string: firstNamePlaceholder, attributes: [NSAttributedStringKey.foregroundColor: color])
		}
		if let emailPlaceholder = emailTF.placeholder {
			emailTF.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: color])
		}
		if let passwordPlaceholder = passwordTF.placeholder {
			passwordTF.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: color])
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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


	@objc private func createNewAccount() {
		guard let name = self.firstNameTF.text, name != "" else {
			showAlert(title: "Please enter a name", message: ""); return
		}
		guard let email = self.firstNameTF.text, email != "" else {
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

		//Create user in Auth
		Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
			if error != nil { print(error); return }
			guard let user = user else {self.showAlert(title: "Error creating profile. Try Again", message: ""); return}

			if user.uid == Auth.auth().currentUser?.uid {
				//Add user to database
				DBService.manager.addLover(uid: user.uid, name: name, email: email, profileImage: image)
				self.transitionToMain()
			}
		})
	}


	private func transitionToMain(){
		//transition to Main
		let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
		if let window = UIApplication.shared.delegate?.window {
			window?.rootViewController = mainVC
		}
	}

	// MARK: Camera
	func addProfileImage() {
		let alertController = UIAlertController(title: "Add profile image", message: "", preferredStyle: UIAlertControllerStyle.alert)
		let existingPhotoAction = UIAlertAction(title: "Choose Existing Photo", style: .default) { (alertAction) in
			self.launchCameraFunctions(type: UIImagePickerControllerSourceType.photoLibrary)
		}
		let newPhotoAction = UIAlertAction(title: "Take New Photo", style: .default) { (alertAction) in
			self.launchCameraFunctions(type: UIImagePickerControllerSourceType.camera)
		}
		alertController.addAction(existingPhotoAction)
		alertController.addAction(newPhotoAction)
		present(alertController, animated: true, completion: nil)
	}

	//Camera Functions
	func launchCameraFunctions(type: UIImagePickerControllerSourceType){
		if UIImagePickerController.isSourceTypeAvailable(type){
//			let imagePicker = UIImagePickerController()
			imagePicker.sourceType = type
			imagePicker.allowsEditing = true
			self.present(imagePicker, animated: true, completion: nil)
		}
	}

}


// MARK: TextField Delegate
extension SignupVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}


// MARK: Create User
extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
			//set button image
			profileImageButton.setImage(selectedImage, for: .normal)
			print("image set to button")

		}
		imagePicker.dismiss(animated: true, completion: nil)
	}

	//Cancel camera
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		imagePicker.dismiss(animated: true, completion: nil)
	}

}
