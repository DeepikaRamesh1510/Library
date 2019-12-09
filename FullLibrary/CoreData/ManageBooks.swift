//
//  ManageBooks.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ManageBooks {
    
    static let shared = ManageBooks()
    init() {}
    
    lazy var dataManager = DataManager()
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Book")
    
    // MARK: CRUD operations for a book
	func insertNewBook(book: Book, flowState: FlowState ,sender: UIViewController,errorHandler: (CRUDError) -> Void ) {
		guard let bookISBN = book.isbn else {
			let insertionError = CRUDError(errorType: .persistingError, errorMessage: "Unable to save data")
            errorHandler(insertionError)
			return
		}
		if flowState == .create{
			if let bookAlreadyAvailable = fetchParticularBook(isbn: bookISBN), bookAlreadyAvailable.isEqual(book) {
				dataManager.saveContext(errorHandler: errorHandler)
			} else {
				let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
				sender.showAlert(title: "Alert", message: "Another book same ISBN already exists!", actions: [okAlertAction])
			}
		} else {
			dataManager.saveContext(errorHandler: errorHandler)
		}
    }
    
    
    func fetchBooks() -> [Any]? {
        do {
            return try fetchFromTheDB(fetchRequest: fetchRequest)
        } catch {
            print(error)
            return nil
        }
    }
    
    func fetchFromTheDB(fetchRequest: NSFetchRequest<NSFetchRequestResult>) throws -> [Any]   {
        let result = try dataManager.persistentContainer.viewContext.fetch(fetchRequest)
        return result
    }
    
    func fetchParticularBook(isbn: String) -> Book? {
        fetchRequest.predicate = NSPredicate(format: "isbn=%@", isbn)
        do {
            let result = try fetchFromTheDB(fetchRequest: fetchRequest)
            let book = result[0] as? Book
            return book
        } catch {
            print("Error occurred while trying to fetch a book!")
            return nil
        }
        
    }
    
    func deleteBook(isbn: String,errorHandler: ((CRUDError) -> Void)?){
//        fetchRequest.predicate = NSPredicate(format: "isbn=%@", )
//        do {
//            let result = try fetchFromTheDB(fetchRequest: fetchRequest)
			let book = fetchParticularBook(isbn: isbn)
            guard let bookToDelete = book else {
                print("Unable to find the book in the list!")
				let deletionError = CRUDError(errorType: .deletionError, errorMessage: "Unable to find the book")
				guard let errorHandler = errorHandler else {
					return
				}
				errorHandler(deletionError)
                return
            }
		guard let errorHandler = errorHandler else {
			return
		}
            dataManager.persistentContainer.viewContext.delete(bookToDelete)
            dataManager.saveContext(errorHandler: errorHandler)
//        } catch {
//
//        }
    }
    
    func createManagedObjectBook(errorHandler: (CRUDError) -> Void) -> Book? {
        guard let bookEntity = NSEntityDescription.entity(forEntityName: "Book", in: dataManager.persistentContainer.viewContext) else {
            let creationError = CRUDError(errorType: .creationError, errorMessage: "Failed to create entity for the book")
            errorHandler(creationError)
            return nil
        }
        let book = Book(entity: bookEntity, insertInto: dataManager.persistentContainer.viewContext)
        return book
    }
    
    
    
}
