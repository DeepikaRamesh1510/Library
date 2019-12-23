//
//  ContactsViewModel.swift
//  FullBooks
//
//  Created by user on 22/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import CoreData
import UIKit

protocol ContactsDelegate: class {
	func loginStatus()
	func displayToast(message: String)
}

extension ContactsDelegate where Self: UIViewController {
	func displayToast(message: String) {
		self.showToast(message: message)
	}
}


class ContactsViewModel {
	
	var networkManager: NetworkManager
	var coreDataManager: CoreDataManager
	weak var delegate: ContactsDelegate?
	let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.contact.rawValue)
	init(networkManager: NetworkManager, coreDataManager: CoreDataManager) {
		self.networkManager = networkManager
		self.coreDataManager = coreDataManager
	}
	
	func isContactAvailable(emailId: String) -> Bool {
		fetchRequest.predicate = NSPredicate(format: "emailId=%@", emailId)
		do {
//			guard let result =
		} catch {
			
		}
		return false
	}
	
	func createNewContact(emailId: String, fullName: String) {
		if isContactAvailable(emailId: emailId) {
			delegate?.displayToast(message: "User already registered!")
			return
		}
		insertNewContactToStore(emailId: emailId, fullName: fullName)
	}
	
	func insertNewContactToStore(emailId: String,fullName: String) {
		guard let contactEntity = coreDataManager.instantiateEntity(forName: CoreDataEntity.contact.rawValue) else {
			print("Failed to Create new contact!")
			return
		}
		let newContact = Contact(entity: contactEntity, insertInto: coreDataManager.persistentContainer.viewContext)
	}
	
	func getLoggedInUserDetail(emailId: String, completionHandler: (Contact?,Error?) -> Void) {
		fetchRequest.predicate = NSPredicate(format: "isLoggedIn=%@", true)
		do {
			guard let result = try coreDataManager.fetch(fetchRequest: fetchRequest), let userDetails = result.last as? Contact else {
				completionHandler(nil,nil)
				return
			}
			completionHandler(userDetails,nil)
		} catch {
			completionHandler(nil,error)
		}
	}
	
	func loginUser() {
		
	}
	
	func logoutUser() {
		
	}
}
