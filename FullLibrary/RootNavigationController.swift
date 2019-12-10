//
//  RootNavigationController.swift
//  FullLibrary
//
//  Created by user on 02/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    override func viewDidLoad() {
        print("root navigation controller is loaded")
        super.viewDidLoad()
        modifyAccordingToUserPrefernces()
        validateSession()
        configureNaviagtionBar()
    }
    
    func configureNaviagtionBar(){
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
    }
   
    func validateSession() {
        print("Entered validation process")
        var isLoggedIn = true
        if isLoggedIn {
			guard let rootViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.rootViewController.rawValue) as? RootViewController else {
                    print("Failed to instatiate root view controller!")
                     return
                }
            self.pushViewController(rootViewController, animated: true)
        } else {
			guard let loginViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.loginViewController.rawValue) as? LoginViewController else {
                    print("Failed to instatiate login view controller!")
                     return
                }
            self.pushViewController(loginViewController, animated: true)
        }
        
    }
    
    func modifyAccordingToUserPrefernces() {
//        print("Changed according to the user preferences")
//        if let userPreferedColor = UserDefaults.standard.string(forKey: UserPrefernces.colorTheme.rawValue), let newColorTheme = ColorPalette(rawValue: userPreferedColor) {
//            ColorPicker.changeThemeColor(newColor: newColorTheme)
//        }
//        let colorTheme = ColorPicker.getThemeColor()
        self.navigationBar.barTintColor = UIColor.systemYellow
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
	
}
