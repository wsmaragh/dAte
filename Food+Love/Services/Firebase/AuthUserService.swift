
//  AuthUserService.swift
//  Food+Love
//  Created by Winston Maragh on 3/15/18.
//  Copyright © 2018 Winston Maragh. All rights reserved.

import Firebase
import UIKit


@objc protocol AuthUserServiceDelegate: class {
    //create user delegate protocols
    @objc optional func didFailCreatingUser(_ userService: AuthUserService, error: Error)
    @objc optional func didCreateUser(_ userService: AuthUserService, user: User)
    
    //sign out delegate protocols
    @objc optional func didFailSigningOut(_ userService: AuthUserService, error: Error)
    @objc optional func didSignOut(_ userService: AuthUserService)
    
    //sign in delegate protocols
    @objc optional func didFailSignIn(_ userService: AuthUserService, error: Error)
    @objc optional func didSignIn(_ userService: AuthUserService, user: User)
}


class AuthUserService: NSObject {
	static let manager = AuthUserService()
    weak var delegate: AuthUserServiceDelegate?

    public static func getCurrentUser() -> User?{
			return Auth.auth().currentUser
    }
	
	public func createUser(name: String, email: String, password: String, profileImage: UIImage?) {
		Auth.auth().createUser(withEmail: email, password: password){(user, error) in
			if let error = error {self.delegate?.didFailCreatingUser?(self, error: error)}
			else if let user = user {
				let changeRequest = user.createProfileChangeRequest()
				changeRequest.displayName = name
				changeRequest.commitChanges(completion: {(error) in
					if let error = error {print("changeRequest error: \(error)")}
					else {
						print("changeRequest was successful for username: \(name)")
						DBService.manager.addLover(name: name, email: email, profileImage: profileImage ?? #imageLiteral(resourceName: "user2"))
					}
					self.delegate?.didCreateUser?(self, user: user)
				})
			}
		}
	}

	public func changeAuthProfilePhoto(urlString: String) {
		let currentUser  = Auth.auth().currentUser!
		let changeRequest = currentUser.createProfileChangeRequest()
		changeRequest.photoURL = URL(string: urlString)
		changeRequest.commitChanges(completion: {(error) in
			if let error = error {print("changeRequest error: \(error)")}
			else {
				print("changeRequest was successful for username: \(currentUser.displayName)")
			}
		})
	}
	public func changeAuthProfileName(name: String) {
		let currentUser  = Auth.auth().currentUser!
		let changeRequest = currentUser.createProfileChangeRequest()
		changeRequest.displayName = name
		changeRequest.commitChanges(completion: {(error) in
			if let error = error {print("changeRequest error: \(error)")}
			else {
				print("changeRequest was successful for username: \(currentUser.displayName)")
			}
		})
	}

    public func signOut() {
        do{
            try Auth.auth().signOut()
            delegate?.didSignOut?(self) //inform delegate of successful sign out
        } catch {
            delegate?.didFailSigningOut!(self, error: error) //inform delegate of error
        }
    }


    public func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) {(user, error) in
            if let error = error { self.delegate?.didFailSignIn?(self, error: error) } //inform delegate of signin error
						else if let user = user { self.delegate?.didSignIn?(self, user: user) } //inform delegate of signin success
        }
    }
    
    
}

