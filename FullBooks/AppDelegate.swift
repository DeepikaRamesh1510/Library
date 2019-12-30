//
//  AppDelegate.swift
//  FullLibrary
//
//  Created by user on 02/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import GoogleSignIn
import SwiftKeychainWrapper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var code: String?
//    var floatingButtonController: FloatingButtonController?
	
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		GIDSignIn.sharedInstance().clientID = "815573621228-pb8lfr4gg2bsl02aqma64emd6kstd6iu.apps.googleusercontent.com"
//        OAuthInstance().getCodeByProvidingTheClientID()
//		floatingButtonController = FloatingButtonController()
//		floatingButtonController?.floatingButton.addTarget(self, action: #selector(presentBookViewController), for: .touchUpInside)
        return true
    }
	
	open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }

}
    
