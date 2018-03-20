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


	@IBAction func signup(_ sender: UIButton) {
		//handleRegister()
		let setupProfileVC = SetupProfileVC()
		self.navigationController?.pushViewController(setupProfileVC, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
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

	func addShadeView(){
		let shade = UIView(frame: self.view.frame)
		shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.9)
		view.addSubview(shade)
		view.sendSubview(toBack: shade)
	}


	func makeNavigationBarTransparent(){
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.tintColor = UIColor.white
		self.navigationController?.navigationBar.barTintColor = UIColor.white
		self.navigationController?.navigationBar.titleTextAttributes = [
			NSAttributedStringKey.foregroundColor : UIColor.white
		]
	}

	func setPlaceholderTextColor(color: UIColor){
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
		print("create new account button pressed")
		guard let nameText = self.firstNameTF.text else {print("name is nil"); return}
		guard !nameText.isEmpty else {print("name field is empty"); return}
		guard let emailText = self.emailTF.text else {print("email is nil"); return}
		guard !emailText.isEmpty else {print("email field is empty"); return}
		guard let passwordText = self.passwordTF.text else {print("password is nil"); return}
		guard !passwordText.isEmpty else {print("password field is empty"); return}
		if passwordText.contains(" ") {
			showAlert(title: "Come on, really!? No spaces allowed!", message: nil)
			return
		}
		authUserService.createUser(name: nameText, email: emailText, password: passwordText)
	}

}


// MARK: Create User
extension SignupVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@objc func handleRegister() {
		guard let email = emailTF.text, let password = passwordTF.text, let name = firstNameTF.text else {
			print("Form is not valid")
			return
		}

		Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
			if error != nil { print(error!); return }
			guard let uid = user?.uid else { return }
			//successfully authenticated user
			let imageName = UUID().uuidString
			let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
			if let profileImage = self.profileImageView.image,
					let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
				storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
					if error != nil { print(error!); return }
					if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
						let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
						self.registerUserIntoDatabaseWithUID(uid, values: values as [String : String])
					}
				})
			}
		}
	}

	// Register User in Database
	fileprivate func registerUserIntoDatabaseWithUID(_ uid: String, values: [String: String]) {
		let ref = Database.database().reference()
		let usersReference = ref.child("users").child(uid)
		usersReference.updateChildValues(values, withCompletionBlock: { (error, ref) in
			if error != nil { print(error!); return }
			let lover = Lover(dictionary: values)
			self.messagesController?.setupNavBarWithUser(lover)
//			self.dismiss(animated: true, completion: nil)
		})
	}


	@objc func handleSelectProfileImageView() {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
	}


	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		var selectedImageFromPicker: UIImage?
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			selectedImageFromPicker = editedImage
		} else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			selectedImageFromPicker = originalImage
		}
		if let selectedImage = selectedImageFromPicker {
			profileImageView.image = selectedImage
		}
		dismiss(animated: true, completion: nil)
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		print("canceled picker")
		dismiss(animated: true, completion: nil)
	}

}
