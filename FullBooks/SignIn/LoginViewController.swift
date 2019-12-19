//
//  LoginViewController.swift
//  FullLibrary
//
//  Created by user on 02/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    var isUsernameValid = false
    var isPasswordValid = false
	
    override func viewDidLoad() {
		super.viewDidLoad()
		GIDSignIn.sharedInstance()?.presentingViewController = self
		GIDSignIn.sharedInstance()?.delegate = self
//		navBar.isHidden = false
    }
    
  
	@IBAction func signInWithGoogle(_ sender: Any) {
		GIDSignIn.sharedInstance()?.signIn()
	}
	
}
