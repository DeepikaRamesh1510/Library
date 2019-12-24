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
	func validateLogginStatus(error: CRUDError?)
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
	
	func createNewContact(emailId: String, fullName: String) {
		guard let contactEntity = coreDataManager.instantiateEntity(forName: CoreDataEntity.contact.rawValue) else {
			print("Failed to Create new contact!")
			return
		}
		let newContact = Contact(entity: contactEntity, insertInto: coreDataManager.persistentContainer.viewContext)
		newContact.emailId = emailId
		newContact.fullName = fullName
		newContact.isLoggedIn = true
		coreDataManager.saveContext{ (error) in
			delegate?.validateLogginStatus(error: error)
		}
	}
	
	func getLoggedInUserDetail(completionHandler: (Contact?,Error?) -> Void) {
//		fetchRequest.predicate = NSPredicate(format: "isLoggedIn=%@", true)
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
	
}
