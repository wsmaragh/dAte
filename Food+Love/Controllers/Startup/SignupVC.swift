
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
		guard let name = self.firstNameTF.text,
					let email = self.emailTF.text,
					let password = self.passwordTF.text
			else {return}
		guard !name.isEmpty else {print("name field is empty"); return}
		guard !email.isEmpty else {print("email field is empty"); return}
		guard !password.isEmpty else {print("password field is empty"); return}
		if password.contains(" ") {
			showAlert(title: "Come on, really!? No spaces allowed!", message: nil)
			return
		}
//		authUserService.createUser(name: nameText, email: emailText, password: passwordText)

		//Create user in Auth
		Auth.auth().createUser(withEmail: email, password: password, completion: { (user: User?, error) in
			if error != nil { print(error ?? "Not Trackable Error"); return }
			guard let uid = user?.uid else { return}
			let imageName = "my_profile_image_\(uid).png"
			// upload image
			let storageRef = Storage.storage().reference().child("Profile_images").child(imageName)
			if let profileImage = self.profileImageView.image ,let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
				storageRef.putData(uploadData, metadata: nil, completion: { (metadata, err) in
					if err != nil { print(err ?? "not traceable error"); return }
					if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
						let values = ["name": name, "email": email,"profileImageUrl": profileImageUrl]
						//Regster user in Database
						let ref = Database.database().reference()
						let userRef = ref.child("users").child(uid)
						userRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
							if err != nil { print(err ?? "Not Trackable Error"); return }
							self.messagesController?.getUserInfoFromDatabase()
						})
					}
				})
			}
		})

	}



	// Select Profile Image
	@objc func selectProfileImage() {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.allowsEditing = true
		present(picker, animated: true, completion: nil)
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
		if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
			selectedImageFromPicker = editedImage
		} else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
			selectedImageFromPicker = originalImage
		}
		if let selectedImage = selectedImageFromPicker {
			profileImageView.image = selectedImage
			profileImageView.layer.cornerRadius = 40.0
			profileImageView.layer.masksToBounds = true
		}
		dismiss(animated: true, completion: nil)
	}

	//Cancel camera
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

}
