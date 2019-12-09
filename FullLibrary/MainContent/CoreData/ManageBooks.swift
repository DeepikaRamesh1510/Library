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
    
	
	func isBookAvailable(isbn: String) -> Bool {
		guard let _ = fetchParticularBook(isbn: isbn) else {
			return false
		}
		return true
	}
	
    // MARK: CRUD operations for a book
	func insertNewBook(title: String,author: String, isbn: String,noOfPages: Int16?,synopsis: String?,genre: String?, errorHandler: (CRUDError) -> Void ) -> Book? {
		guard let book = self.createManagedObjectBook(errorHandler: errorHandler) else {
			let insertionError = CRUDError(errorType: .creationError, errorMessage: "Unable to create a new book!")
			             errorHandler(insertionError)
			return nil
		}
		book.title = title
		book.authorName = author
		book.genre = genre
		book.isbn = isbn
		book.synopsis = synopsis
		dataManager.saveContext(errorHandler: errorHandler)
		return book
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
			guard  result.count > 0 else {
				return nil
			}
			guard let book = result[0] as? Book else {
				return nil
			}
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
