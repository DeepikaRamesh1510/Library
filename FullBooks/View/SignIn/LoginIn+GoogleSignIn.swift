//
//  File.swift
//  FullBooks
//
//  Created by user on 19/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import GoogleSignIn
import SwiftKeychainWrapper

extension LoginViewController: GIDSignInDelegate, ContactsDelegate {
	func validateLogginStatus(error: CRUDError?) {
		guard let error = error else {
		navigationController?.makeTabbarPageRootViewController()
			return
		}
		print(error)
		self.showToast(message: "Login Failed!")
	}
	

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
			showToast(message: "Login Failed")
            return
        }
		let emailId = user.profile.email
		let fullName = user.profile.name
		contactsViewModel.createNewContact(emailId: emailId!, fullName: fullName!)
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                     withError error: Error!) {
        print("Error occured while tryong to sign in!")
    }
    
}
