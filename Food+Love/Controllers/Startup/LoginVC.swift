
//  LoginVC.swift
//  Food+Love
//  Created by Winston Maragh on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import AVKit
import FirebaseAuth


class LoginVC: UIViewController {

	// MARK:
	@IBOutlet weak var emailTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!
	@IBOutlet weak var loginButton: UIButton!
	var messagesController: MatchesVC?


	//Facebook button
	//Google button
	//Twitter Button

	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		//		setupVideoBackground()
		self.emailTF.underlined(color: .white)
		self.passwordTF.underlined(color: .white)
		self.emailTF.leftViewMode = .always
		self.passwordTF.leftViewMode = .always
		makeNavigationBarTransparent()
		setPlaceholderTextColor(color: UIColor.lightText)

		//Shade
		let shade = UIView(frame: self.view.frame)
		shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
		view.addSubview(shade)
		view.sendSubview(toBack: shade)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(false)
		self.view.alpha = 0.0
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
		if let emailPlaceholder = emailTF.placeholder {
			emailTF.attributedPlaceholder = NSAttributedString(string: emailPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: color])
		}
		if let passwordPlaceholder = passwordTF.placeholder {
			passwordTF.attributedPlaceholder = NSAttributedString(string: passwordPlaceholder, attributes: [NSAttributedStringKey.foregroundColor: color])
		}
		emailTF.textColor = .white
		passwordTF.textColor = .white
	}


	// MARK: Actions for buttons
	@IBAction func loginInUser(){
		guard let email = emailTF.text, let password = passwordTF.text else {	return }
		Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
			if error != nil { print(error); return }
			//successfully logged in our user
			let user = Auth.auth().currentUser!
			print(user)
			print(user.uid)
			print(user.displayName)
			print(user.email!)
			print(user.photoURL)

			let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
			if let window = UIApplication.shared.delegate?.window {
				window?.rootViewController = mainVC
			}
		})

	}


	@IBAction func FacebookLogin(){


	}

	@IBAction func GoogleLogin(){


	}

	// MARK: Background Video Player
	func setupVideoBackground() {
		//video URL
		guard let videoURL = Bundle.main.url(forResource: "date", withExtension: "mp4") else {return}

		//Shade
		let shade = UIView(frame: self.view.frame)
		shade.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
		view.addSubview(shade)
		view.sendSubview(toBack: shade)

		//AV Player
		var avPlayer = AVPlayer()
		avPlayer = AVPlayer(url: videoURL)
		let avPlayerLayer = AVPlayerLayer(player: avPlayer)
		avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
		avPlayer.volume = 0
		avPlayer.actionAtItemEnd = AVPlayerActionAtItemEnd.none
		avPlayerLayer.frame = view.layer.bounds

		//Layer
		let layer = UIView(frame: self.view.frame)
		view.backgroundColor = UIColor.clear
		view.layer.insertSublayer(avPlayerLayer, at: 0)
		view.addSubview(layer)
		view.sendSubview(toBack: layer)

		//Notification
		NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishedPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: avPlayer.currentItem)

		//Play video
		avPlayer.play()
	}

	@objc func playerDidFinishedPlaying(notification: NSNotification) {
		if let player = notification.object as? AVPlayerItem {
			player.seek(to: kCMTimeZero, completionHandler: nil)
		}
	}

	// MARK:
	public static func storyboardInstance() -> LoginVC {
		let storyboard = UIStoryboard(name: "LoginVC", bundle: nil)
		let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
		return loginVC
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.emailTF.resignFirstResponder()
		self.passwordTF.resignFirstResponder()
	}

	@objc private func forgotPassword(){
		//TODO: Check if email is a verified user
		Auth.auth().sendPasswordReset(withEmail: self.emailTF.text!){(error) in
			print("sent")
			self.showAlert(title: "Password Reset", message: "Password email sent, check spam inbox")
		}
	}

	private func showAlert(title: String, message: String?) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Ok", style: .default) {alert in }
		alertController.addAction(okAction)
		present(alertController, animated: true, completion: nil)
	}

}


// MARK: TextField Delegate
extension LoginVC: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
