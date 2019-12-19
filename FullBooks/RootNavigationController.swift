//
//  RootNavigationController.swift
//  FullLibrary
//
//  Created by user on 02/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import GoogleSignIn

class RootNavigationController: UINavigationController {
	
	lazy var dataManager = DataManager(modalName: "FullBooks")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationBar(barTintColor: UIColor.systemYellow, tintColor: UIColor.black)
		checkIfUserAlreadyLoggedIn()
		//        configureNaviagtionBar()
	}
	
	func checkIfUserAlreadyLoggedIn() {
		let loginFlag = true
//		let loginFlag = userDefault.bool(forKey: isLoggedIn)
		if loginFlag {
			self.setTabbarRootViewController()
		} else {
			self.setLogginRootViewController()
		}
	}
	
	
	
}
