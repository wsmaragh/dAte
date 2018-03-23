//
//  ProfileVC.swift
//  Food+Love
//
//
//



import UIKit
import Firebase


class ProfileVC: UIViewController {

	// MARK: Action Buttons
	@IBOutlet weak var logoutButton: UIBarButtonItem!
	@IBOutlet weak var settingsButton: UINavigationItem!


	@IBAction func logoutPressed(_ sender: UIBarButtonItem) {
		let alertView = UIAlertController(title: "Are you sure you want to Logout?", message: nil, preferredStyle: .alert)
		let yesOption = UIAlertAction(title: "Yes", style: .destructive) { (alertAction) in
			self.logout()
			//Go to WelcomeVC
//			let welcomeVC = WelcomeVC()
//			let welcomeNavCon = UINavigationController(rootViewController: welcomeVC)
//			self.present(welcomeNavCon, animated: true)
		}
		let noOption = UIAlertAction(title: "No", style: .cancel, handler: nil)
		alertView.addAction(yesOption)
		alertView.addAction(noOption)
		present(alertView, animated: true, completion: nil)
	}

	@IBAction func settingsPressed(_ sender: UIBarButtonItem) {


	}


	// MARK: Properties
	private var currentAuthUser: User? 


	// MARK: View Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		currentAuthUser = Auth.auth().currentUser!
//		configureNavBar()
	}


	//MARK: Helper Functions


	func logout(){
		do {
			try Auth.auth().signOut()
			let welcomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WelcomeController")
			if let window = UIApplication.shared.delegate?.window {
				window?.rootViewController = welcomeVC
			}
		}
		catch { print("Error signing out: \(error)") }
	}

}
