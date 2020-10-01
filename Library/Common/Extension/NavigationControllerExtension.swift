//
//  Extension+NavigationController.swift
//  FullLibrary
//
//  Created by user on 07/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension UINavigationController {

    func changeNavigationBarContent(target: UIViewController,title: String, rightBarButton: UIBarButtonItem?){
		self.navigationBar.topItem?.title = title
        target.navigationItem.rightBarButtonItem = rightBarButton
    }
	func navigationBar(barTintColor: UIColor, tintColor: UIColor) {
        self.navigationBar.barTintColor = UIColor.systemYellow
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
	
	func hideNavigationBar() {
		self.isNavigationBarHidden = true
	}
	
	func displayNavigationBar() {
		self.isNavigationBarHidden = false
	}
	
	func makeTabbarPageRootViewController() {
		guard let rootViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.rootViewController.rawValue) as? RootViewController else {
			print("Failed to instatiate root view controller!")
			return
		}
		self.setViewControllers([rootViewController], animated: true)
	}
	
	func makeLogginPageRootViewController() {
		guard let loginViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.loginViewController.rawValue) as? LoginViewController else {
			print("Failed to instatiate login view controller!")
			return
		}
		self.setViewControllers([loginViewController], animated: true)
	}
	
}
