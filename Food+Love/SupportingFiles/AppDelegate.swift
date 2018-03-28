
//  AppDelegate.swift
//  Food+Love
//  Created by C4Q on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

//    override init() {
//        super.init()
//        FirebaseApp.configure()
//    }

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

        FirebaseApp.configure()

		//Google Sign-in
//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self

		//FaceBook Login
		//FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

		//Navigation Bar
			UINavigationBar.appearance().tintColor = UIColor.white
			UINavigationBar.appearance().alpha = 1.0
			UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]

		//Tab Bar
			UITabBar.appearance().tintColor = UIColor.white
			UITabBar.appearance().alpha = 1.0
			UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)

		let startingVC: UIViewController?

		//Check if user is authenticated
		if Auth.auth().currentUser == nil {
			startingVC = UIStoryboard(name: "Welcome", bundle: nil).instantiateViewController(withIdentifier: "WelcomeController")
		} else {
			startingVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainController")
		}

		//Window setup
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.makeKeyAndVisible()
		window?.rootViewController = startingVC

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

}


// MARK: Google Sign-in Delegate
extension AppDelegate: GIDSignInDelegate {

	//Google Sign In
	func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
		if let error = error {print("Failed to log into Google. Error: \(error)"); return}
		print("Successfully logged into Google")

		guard let authentication = user.authentication else { return }
		let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
																									 accessToken: authentication.accessToken)
		Auth.auth().signIn(with: credential) {(user, error) in
			if let error = error {
				print("Failed to create a Firebase user with Google Account: ", error)
				return
			}
			guard let uid = user?.uid else {return}
			print("Successfully logged into Firebase with Google. User: \(user), with ID: \(uid)")
		}
	}

	//Google disconnect
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		// Perform any operations when the user disconnects from app here.
		// ...
	}

//		@available(iOS 9.0, *)
//		func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
//			-> Bool {
//				return self.application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: "")
//		}

	
	//	For Google Sign-in
	@available(iOS 9.0, *)
	func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
		-> Bool {

			////FaceBook Sign-in
			let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])

			//Google Sign-in
			//			GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
			GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
			return handled
	}

	//for Google-Sign in to run on iOS 8 and older,
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
		//			return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
		return handled
	}


}

