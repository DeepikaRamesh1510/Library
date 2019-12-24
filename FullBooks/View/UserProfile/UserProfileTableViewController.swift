//
//  UserProfileTableViewController.swift
//  FullBooks
//
//  Created by user on 22/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class UserProfileTableViewController: UITableViewController {
	
	@IBOutlet var userEmailId: UILabel!
	@IBOutlet var username: UILabel!
	@IBOutlet var userImage: UIImageView!
	var networkManager: NetworkManager!
	var coreDataManager: CoreDataManager!
	override func viewDidLoad() {
		super.viewDidLoad()
		initializeDataManager()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		setNavigationBarTitle()
	}
	
	func setNavigationBarTitle() {
	self.navigationController?.changeNavigationBarContent(target: self, title: "User Profile", rightBarButton: nil)
	}
	
	
	func initializeDataManager() {
		let rootNavigationController = self.navigationController as! RootNavigationController
		networkManager = rootNavigationController.networkManager
		coreDataManager = rootNavigationController.coreDataManager
	}
	
	
	@IBAction func presentLogoutConfirmationAlert(_ sender: Any) {
		let okAction = UIAlertAction(title: "Ok", style: .destructive) { (action) in
			self.logoutUser()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
		
		self.showAlert(title: "Alert", message: "Are you sure you want to logout?", actions: [cancelAction, okAction])
	}
	
	func logoutUser() {
		coreDataManager.deletePersistantStore { (error) in
			guard let error = error else {
				self.showToast(message: "Logged out!")
				self.navigationController?.makeLogginPageRootViewController()
				return
			}
			print(error)
			self.showToast(message: "Logout Failed!")
		}
		
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
}
