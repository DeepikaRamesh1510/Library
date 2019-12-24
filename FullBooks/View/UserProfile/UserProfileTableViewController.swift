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
	var contactViewModel: ContactsViewModel!
	override func viewDidLoad() {
		super.viewDidLoad()
		initializeDataManager()
		getUserDetails()
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
		contactViewModel = ContactsViewModel(networkManager: networkManager, coreDataManager: coreDataManager)
//		contactViewModel.delegate = self
	}
	
	@IBAction func presentLogoutConfirmationAlert(_ sender: Any) {
		let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
			self.logoutUser()
		}
		let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
		
		self.showAlert(title: "Alert", message: "Are you sure you want to logout?", actions: [noAction, yesAction])
	}
	
	func getUserDetails() {
		contactViewModel.getLoggedInUserDetail { (user, error) in
			if let error = error {
				print("Failed to fetch the logged in user details! - \(error)")
				navigationController?.makeLogginPageRootViewController()
				return
			}
			guard let user = user else {
				print("Failed to fetch the logged in user!")
				return
			}
			self.username.text = user.fullName
			self.userEmailId.text = user.emailId
		}
	}
	
	func logoutUser() {
		coreDataManager.restorePersistantStore { (error) in
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
