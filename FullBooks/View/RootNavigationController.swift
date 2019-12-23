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
	
	lazy var coreDataManager = CoreDataManager(modelName: "FullBooks")
	lazy var networkManager = NetworkManager()
	override func viewDidLoad() {
		super.viewDidLoad()
//		self.navigationBar(barTintColor: UIColor.systemYellow, tintColor: UIColor.black)
		checkIfUserAlreadyLoggedIn()
	}
	
	func checkIfUserAlreadyLoggedIn() {
		let loginFlag = true
//		let loginFlag = userDefault.bool(forKey: isLoggedIn)
		if loginFlag {
			self.makeTabbarPageRootViewController()
		} else {
			self.makeLogginPageRootViewController()
		}
	}
	
	
	
}
