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

protocol FullLibraryDelegate: class {
	func reloadContent(book: [Book])
	func displayToast(message: String)
}

extension FullLibraryDelegate where Self: UIViewController {
	func displayToast(message: String) {
		self.showToast(message: message)
	}
}
class FullBooksViewModel {
	
	weak var delegate: FullLibraryDelegate?
	var coreDataManager : CoreDataManager
	let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.books.rawValue)
	
	init(coreDataManager: CoreDataManager) {
		self.coreDataManager = coreDataManager
	}

	func isBookAvailable(bookId: String) -> Bool {
		guard let _ = fetchParticularBook(bookId: bookId) else {
			return false
		}
		return true
	}
	
    // MARK: CRUD operations for a book
	func insertNewBook(title: String,author: String, bookId: String,noOfPages: Int16?,synopsis: String?,genre: String?, imageData: Data?, rating: Float?, numberOfCopies: Int16, errorHandler: (CRUDError?) -> Void ) {
		guard let book = self.istantiateBookManagedObject(errorHandler: errorHandler) else {
			let insertionError = CRUDError(errorType: .creationError, errorMessage: "Unable to create a new book!")
			             errorHandler(insertionError)
			return
		}
		book.title = title
		book.authorName = author
		book.bookId = bookId
		book.rating = rating ?? 0.0
		book.favorite = false
		book.genre = "Genre not specified"
		book.image = imageData
		book.noOfCopies = numberOfCopies
		book.noOfPages = noOfPages ?? 0
		book.synopsis = synopsis
		coreDataManager.saveContext(errorHandler: errorHandler)
    }
    
	func fetchBooks() {
		guard let delegate = delegate else {
			print("Full library delegate is nil!")
			return
		}
        do {
			guard let result = try coreDataManager.fetch(fetchRequest: fetchRequest) else {
				delegate.displayToast(message: "Books Fetch Failed!")
				return
			}
			delegate.reloadContent(book: result.compactMap({ $0 as? Book}))
        } catch {
			delegate.displayToast(message: "Books Fetch Failed!")
            print(error)
        }
    }

    func fetchParticularBook(bookId: String) -> Book? {
		fetchRequest.predicate = NSPredicate(format: "bookId=%@", bookId)
        do {
			guard let result = try coreDataManager.fetch(fetchRequest: fetchRequest) else {
				print("Unable to fetch books!")
				return nil
			}
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
	
	func fetchBooksBasedOnSearch(by searchWord: String) {
		let titlePredicate = NSPredicate(format: "title CONTAINS[c] %@", searchWord)
		let authorPredicate = NSPredicate(format: "authorName CONTAINS[c] %@", searchWord)
		fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [titlePredicate, authorPredicate])
		do {
			guard let result = try coreDataManager.fetch(fetchRequest: fetchRequest) else {
				print("Unable to fetch books!")
				delegate?.displayToast(message: "Book not Found!")
				return
			}
			let books = result.compactMap { $0 as? Book }
			delegate?.reloadContent(book: books)
        } catch {
            print("Error occurred while trying to fetch a book!")
			delegate?.displayToast(message: "Error Occurred!")
            return
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
		coreDataManager.persistentContainer.viewContext.delete(bookToDelete)
		coreDataManager.saveContext(errorHandler: errorHandler)
    }
    
    func istantiateBookManagedObject(errorHandler: (CRUDError) -> Void) -> Book? {
		guard let bookEntity = coreDataManager.instantiateEntity(forName: CoreDataEntity.books.rawValue) else {
            let creationError = CRUDError(errorType: .creationError, errorMessage: "Failed to create entity for the book")
            errorHandler(creationError)
            return nil
        }
		let book = Book(entity: bookEntity, insertInto: coreDataManager.persistentContainer.viewContext)
		
        return book
    }
    
	func checkForChanges() -> Bool {
		return coreDataManager.persistentContainer.viewContext.hasChanges
	}
	
}
