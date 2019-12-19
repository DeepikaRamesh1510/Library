//
//  File.swift
//  FullBooks
//
//  Created by user on 19/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import GoogleSignIn
import SwiftKeychainWrapper

extension LoginViewController: GIDSignInDelegate {

    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
		
//        let idToken = user.authentication.idToken
//        let fullName = user.profile.name
//        let email = user.profile.email
//		let refreshTokenForUser = user.authentication.refreshToken
//		userDefault.set(fullName, forKey: UserDefaultKey.userName.rawValue)
//		userDefault.set(email, forKey: UserDefaultKey.emailId.rawValue)
//		userDefault.set(true,forKey: UserDefaultKey.isLoggedIn.rawValue)
//		let userImage = user.profile.imageURL(withDimension: 44)
//		userDefault.setValue(user, forKey: userDetail)
		navigationController?.setTabbarRootViewController()
		
    }
    
    public func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
                     withError error: Error!) {
        print("Error occured while tryong to sign in!")
    }
    
}
