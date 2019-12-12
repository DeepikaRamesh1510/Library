//
//  AppDelegate.swift
//  FullLibrary
//
//  Created by user on 02/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var code: String?
    var floatingButtonController: FloatingButtonController?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        OAuthInstance().getCodeByProvidingTheClientID()
		floatingButtonController = FloatingButtonController()
		floatingButtonController?.floatingButton.addTarget(self, action: #selector(presentBookViewController), for: .touchUpInside)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        print("call back url is returned")
        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }
        if parameters.keys.contains("code") {
            code = parameters["code"]
        }
        return false
    }
	
	@objc func presentBookViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let bookViewController = storyboard.instantiateViewController(withIdentifier: ViewController.bookViewController.rawValue) as? BookViewController else {
			print("Failed to open!")
			return
		}
		floatingButtonController?.isVisible = false
		window?.rootViewController?.present(bookViewController, animated: true, completion: nil)
	}

}
    
