//  AppDelegate.swift
//  Food+Love
//  Created by C4Q on 3/13/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.
import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit

// Firebase Messaging
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

	var window: UIWindow?

	override init() {
		super.init()
		FirebaseApp.configure()
	}

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//        FirebaseApp.configure()

        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        // Register for push notifications
        application.registerForRemoteNotifications()

        // Messaging Delegate
        Messaging.messaging().delegate = self

        // Override point for customization after application launch.

		//Google Sign-in
		//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
		//        GIDSignIn.sharedInstance().delegate = self
		//FaceBook Login
		//FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

		//Navigation Bar
        UIApplication.shared.statusBarStyle = .lightContent
		UINavigationBar.appearance().tintColor = UIColor.white
		UINavigationBar.appearance().alpha = 1.0
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]

		//Tab Bar
		UITabBar.appearance().tintColor = UIColor.white
		UITabBar.appearance().alpha = 1.0
		UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)


		let startingVC: UIViewController?
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

	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		Messaging.messaging().apnsToken = deviceToken
		print("deviceToken: \(deviceToken)")
		if let instanceIdToken = InstanceID.instanceID().token() {
			print("Device token which is good to use with FCM \(instanceIdToken)")
		}
	}

	func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

	}

	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
		print("didFailToRegisterForRemoteNotificationsWithError: \(error)")
	}

	// The callback to handle data message received via FCM for devices running iOS 10 or above.
	func application(received remoteMessage: MessagingRemoteMessage) {
		print(remoteMessage.appData)
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
			print("Successfully logged into Firebase with Google. User: \(user!), with ID: \(uid)")
		}
	}

	//Google disconnect
	func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
		// Perform any operations when the user disconnects from app here.
		// ...
	}

	//	For Google Sign-in
	@available(iOS 9.0, *)
	func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
		-> Bool {

			//FaceBook Sign-in
			let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])

			//Google Sign-in
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


extension AppDelegate: MessagingDelegate {
	// Receive the current registration token
	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

		//Messaging.messaging().apnsToken = deviceToken
		print("Firebase registration token: \(fcmToken)")

		// TODO: If necessary send token to application server.
		// Note: This callback is fired at each app startup and whenever a new token is generated.

		let token = Messaging.messaging().fcmToken
		print("FCM token: \(token ?? "")")
	}
	func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
		print("didReceive remoteMessage: \(remoteMessage)")
	}
}


extension AppDelegate {
    
    fileprivate func configureNavigationTabBar() {
        //transparent background
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isTranslucent = true
        
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.shadow: shadow,
        ]
    }
}
