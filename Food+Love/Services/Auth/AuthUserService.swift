//  AuthUserService.swift
//  POSTR
//  Created by Lisa J on 2/1/18.
//  Copyright © 2018 On-The-Line. All rights reserved.


import Foundation
import Firebase

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
	
	public func createUser(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password){(user, error) in
            if let error = error {self.delegate?.didFailCreatingUser?(self, error: error)} //inform delegate of error
						else if let user = user {
                //update Authenticated user displayName with their email prefix

								//create change Request
                let changeRequest = user.createProfileChangeRequest()
								//add things to change in change request
                changeRequest.displayName = name
//								changeRequest.photoURL = URL(string: "http://santetotal.com/wp-content/uploads/2014/05/default-user-image-0f2a2adaf9515a88fb9b1a911d9f46bb-60x60.png")

							 //commit change request
                changeRequest.commitChanges(completion: {(error) in
                    if let error = error {print("changeRequest error: \(error)")}
										else {
                        print("changeRequest was successful for username: \(name)")
												DBService.manager.addUser() //add user to Database
                        self.delegate?.didCreateUser?(self, user: user) //let delegate know
                    }
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

