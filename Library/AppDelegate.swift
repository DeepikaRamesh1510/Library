//
//  AppDelegate.swift
//  Library
//
//  Created by Deepika on 05/10/20.
//

import UIKit
import Keys
import GoogleSignIn
import SwiftKeychainWrapper
import Firebase
import BehaviourAnalyzer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var code: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        AnalyticsLogger.register([DefaultAnalyticsProvider(), DefaultFirebaseAnalyticsProvider()])
        return true
    }
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url)
    }
    
}
