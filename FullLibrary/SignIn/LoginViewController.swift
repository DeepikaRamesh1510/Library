//
//  LoginViewController.swift
//  FullLibrary
//
//  Created by user on 02/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    var isUsernameValid = false
    var isPasswordValid = false
	
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.loginButton.alpha = 0.5
        self.loginButton.isEnabled = false
//        usernameTextField.addTarget(self, action: validateUsernameTextFieldOnTyping(_:), for: .editingChanged)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor.systemYellow.cgColor
    }
    
//    func validateUsernameTextFieldOnTyping(_ textField: UITextField) {
//        textField.layer.borderColor = UIColor.systemGray6.cgColor
//        isUsernameValid = true
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == usernameTextField, let username = textField.text, username.isValidEmail {
            textField.layer.borderColor = UIColor.systemGray.cgColor
            isUsernameValid = true
        } else if textField == passwordTextField,let password = textField.text, password.isValidPassword {
            textField.layer.borderColor = UIColor.systemGray.cgColor
            isPasswordValid = true
        }
        checkValidityOfUsernameAndPassword()
    }
    
    
    func checkValidityOfUsernameAndPassword() {
        guard isUsernameValid, isPasswordValid else {
            return
        }
        self.loginButton.alpha = 1
        self.loginButton.isEnabled = true
    }
   
}
