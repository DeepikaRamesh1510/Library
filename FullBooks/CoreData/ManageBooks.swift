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
    
	
	func isBookAvailable(bookId: String) -> Bool {
		guard let _ = fetchParticularBook(bookId: bookId) else {
			return false
		}
		return true
	}
	
    // MARK: CRUD operations for a book
	func insertNewBook(title: String,author: String, bookId: String,noOfPages: Int16?,synopsis: String?,genre: String?, imageData: Data?, rating: Float?, numberOfCopies: Int16, errorHandler: (CRUDError?) -> Void ) -> Book? {
		guard let book = self.createManagedObjectBook(errorHandler: errorHandler) else {
			let insertionError = CRUDError(errorType: .creationError, errorMessage: "Unable to create a new book!")
			             errorHandler(insertionError)
			return nil
		}
		book.title = title
		book.authorName = author
		book.genre = genre
		book.bookId = bookId
		book.synopsis = synopsis
		book.image = imageData
		book.rating = rating ?? 0.0
		book.noOfCopies = numberOfCopies
		dataManager.saveContext(errorHandler: errorHandler)
		return book
    }
    
    
    func fetchBooks() -> [Book]? {
        do {
            let result = try fetchFromTheDB(fetchRequest: fetchRequest)
			return result.compactMap({ $0 as? Book})
        } catch {
            print(error)
            return nil
        }
    }
    
    func fetchFromTheDB(fetchRequest: NSFetchRequest<NSFetchRequestResult>) throws -> [Any]   {
        let result = try dataManager.persistentContainer.viewContext.fetch(fetchRequest)
        return result
    }
    
    func fetchParticularBook(bookId: String) -> Book? {
		fetchRequest.predicate = NSPredicate(format: "bookId=%@", bookId)
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
	
	func fetchBooksBasedOnSearch(by searchWord: String) -> [Book] {
		let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", searchWord)
		let authorPredicate = NSPredicate(format: "authorName CONTAINS[c] %@", searchWord)
		fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, authorPredicate])
		do {
			let result = try fetchFromTheDB(fetchRequest: fetchRequest)
			let books = result.compactMap { $0 as? Book }
            return books
        } catch {
            print("Error occurred while trying to fetch a book!")
            return []
        }
		
	}
    
    func deleteBook(bookId: String,errorHandler: ((CRUDError?) -> Void)?){
			let book = fetchParticularBook(bookId: bookId)
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
    
	func checkForChanges() -> Bool {
		return dataManager.persistentContainer.viewContext.hasChanges
	}
	
}
