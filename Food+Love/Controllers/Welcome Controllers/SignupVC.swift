
//  SignupVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVFoundation
import Firebase
import ImageIO
import Photos
import LocalAuthentication



class SignupVC: UIViewController {

	// MARK: Outlet Object Properties
	@IBOutlet weak var profileImageButton: UIButton!
	@IBOutlet weak var firstNameTF: UITextField!
	@IBOutlet weak var emailTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!


	// MARK: Properties
	private var imagePicker = UIImagePickerController()


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		imagePicker.delegate = self
		makeNavigationBarTransparent()
		setupTextFields()
		addShadeView()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		self.view.alpha = 1.0
	}
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(false)
		self.view.alpha = 0.0
	}


	// MARK: Helper Methods
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


	// MARK: Actions
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

	@IBAction func signup(_ sender: UIButtonX) {
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
		guard let image = self.profileImageButton.image(for: .normal) else {return}
		if email.contains(" ") {
			showAlert(title: "No spaces allowed in email!", message: nil); return
		}
		if password.contains(" ") {
			showAlert(title: "No spaces allowed in password!", message: nil); return
		}
		AuthUserService.manager.createUser(name: name, email: email, password: password, profileImage: image)
	}


	fileprivate func addShadeView(){
		let shade = UIView(frame: self.view.frame)
		shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
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
		AuthUserService.manager.createUser(name: name, email: email, password: password, profileImage: image)
		if AuthUserService.getCurrentUser() != nil {
			transitionToMain()
		}
	}


	private func transitionToMain(){
		let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
		if let window = UIApplication.shared.delegate?.window {
			window?.rootViewController = mainVC
		}
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
extension SignupVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}


// MARK: Image Picker
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
			profileImageButton.setImage(selectedImage, for: .normal)
		}
		imagePicker.dismiss(animated: true, completion: nil)
	}

	//Cancel camera
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		imagePicker.dismiss(animated: true, completion: nil)
	}

}





// MARK: Firebase Authentication Delegate
//extension SignupVC: AuthUserServiceDelegate {
//	func didCreateUser(_ userService: AuthUserService, user: User) {
//		AuthUserService.getCurrentUser()?.sendEmailVerification(completion: { (error) in
//			if let error = error {
//				print("error with sending email verification, \(error)")
//				self.showAlert(title: "Error", message: "error with sending email verification")
//				AuthUserService.manager.signOut()
//			}
//			else {
//				print("email verification sent")
//				self.showAlert(title: "Email Verification Sent", message: "Please verify your email. Check your spam folder");
//				AuthUserService.manager.signOut()
//			}
//		})
//	}
//
//	func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
//		showAlert(title: error.localizedDescription, message: nil)
//	}
//
//	func didSignIn(_ userService: AuthUserService, user: User) {
//		print("signed in user: \(user)")
//
////		if user != nil {
////			goToMainApp()
////		} else {
////			AuthUserService.manager.signOut(); return
////		}
//
//		if Auth.auth().currentUser!.isEmailVerified {
//			print("User signed in")
//			goToMainApp()
//		} else {
//			showAlert(title: "Email Verification Needed", message: "Please verify email")
//			AuthUserService.manager.signOut()
//			return
//		}
//	}
//
//	func didFailSignIn(_ userService: AuthUserService, error: Error) {
//		showAlert(title: error.localizedDescription, message: nil)
//	}
//}

