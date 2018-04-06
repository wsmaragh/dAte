
//  LoginVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import LocalAuthentication


class LoginVC: UIViewController {

	// MARK:
	@IBOutlet weak var emailTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	@IBOutlet weak var googleButton: UIButton!
	@IBOutlet weak var facebookButton: FBSDKLoginButton!


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		makeNavigationBarTransparent()
		setupTextFields()
		setupShade()
		setupGoogleButton()
		setupFacebookButton()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(false)
		self.view.alpha = 0.0
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
		self.emailTF.underlined(color: .white)
		self.passwordTF.underlined(color: .white)
		self.emailTF.leftViewMode = .always
		self.passwordTF.leftViewMode = .always
//		emailTF.text = "winstonmaragh@ac.c4q.nyc"
//		emailTF.text = "marlonrugama@ac.c4q.nyc"
		emailTF.text = "xianxianchen@ac.c4q.nyc"
		passwordTF.text = "123456"
		
		//Text Color
		emailTF.textColor = .white
		passwordTF.textColor = .white
		//Placeholder Color
		if let emailPlaceholder = emailTF.placeholder {
			emailTF.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightText])
		}
		if let passwordPlaceholder = passwordTF.placeholder {
			passwordTF.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightText])
		}
	}

	private func setupShade(){
		let shade = UIView(frame: self.view.frame)
		shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
		view.addSubview(shade)
		view.sendSubview(toBack: shade)
	}

	private func setupGoogleButton(){
		GIDSignIn.sharedInstance().uiDelegate = self
		GIDSignIn.sharedInstance().delegate = self
	}

	private func setupFacebookButton(){
		facebookButton.delegate = self
		facebookButton.readPermissions = ["email", "public_profile"]
	}


	// MARK: Actions for buttons
	@IBAction func loginInUser(){
		guard let email = emailTF.text, let password = passwordTF.text else {return}
		if email == "" {showAlert(title: "Please enter an email", message: ""); return}
		if password == "" {showAlert(title: "Please enter a valid password", message: ""); return}
		if password.contains(" "), email.contains(" ") {
			showAlert(title: "No spaces allowed!", message: nil); return
		}
		AuthUserService.manager.signIn(email: email, password: password)
	}


	@IBAction func FacebookLogin(){


	}

	@IBAction func GoogleLogin(){
		GIDSignIn.sharedInstance().signIn()
	}


	private func forgotPassword() {
		guard let email = emailTF.text else {return}
		Auth.auth().sendPasswordReset(withEmail: email) {(error) in
			if let error = error {print("Error sending password reset: \(error)")}
			else {
				self.showAlert(title: "Password Reset", message: "Password email sent, check spam inbox")
			}
		}
	}

	private func transitionToMain(){
		let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
		if let window = UIApplication.shared.delegate?.window {
			window?.rootViewController = mainVC
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.emailTF.resignFirstResponder()
		self.passwordTF.resignFirstResponder()
	}

	private func showAlert(title: String, message: String?) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}

	@objc public func dismissView() {
		self.dismiss(animated: true, completion: nil)
	}

}



// MARK: TextField Delegate
extension LoginVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}


// MARK: Facebook Login
extension LoginVC: FBSDKLoginButtonDelegate {
	func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
		print("logged out of Facebook")
	}
	func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!){
		if let error = error { print("Error signing into Facebook:", error) }
		print("Successfully logged into Facebook")

		let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
		Auth.auth().signIn(with: credential) { (user, error) in
			if let error = error {
				print("Error signing into Firebase with Facebook:", error); return }
			print("User signed into Firebase with Facebook")
			//transition to main
			let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
			if let window = UIApplication.shared.delegate?.window {
				window?.rootViewController = mainVC
			}
		}
	}
}


// MARK: Google Login
extension LoginVC: GIDSignInUIDelegate, GIDSignInDelegate {
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if let error = error {print("Error signing in with Google. Error: \(error)"); return}
		print("Successfully logged into Google")

		guard let authentication = user.authentication else { return }
		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
																									 accessToken: authentication.accessToken)

		Auth.auth().signIn(with: credential, completion: {(user, error) in
			if let error = error {
				print("Failed to create a Firebase user with Google Account: ", error); return
			}
			if let user = user {
				print("Successfully signed in with Google. User: \(user), with ID: \(user.uid)")
				//transition to main
				let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
				if let window = UIApplication.shared.delegate?.window {
					window?.rootViewController = mainVC
				}
			} else {
				print("Error signing into Firebase with Google.")
			}
		})
	}
}

