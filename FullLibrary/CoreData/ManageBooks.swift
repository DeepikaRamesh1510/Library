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
    func insertNewBook(book: Book,errorHandler: (CRUDError) -> Void ) {
        dataManager.saveContext(errorHandler: errorHandler)
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
    
    func fetchAParticularBook(title: String) -> Book? {
        fetchRequest.predicate = NSPredicate(format: "title=%@", title)
        do {
            let result = try fetchFromTheDB(fetchRequest: fetchRequest)
            let book = result[0] as? Book
            return book
        } catch {
            print("Error occurred while trying to fetch a book!")
            return nil
        }
        
    }
    
    func deleteBook(title: String,errorHandler: (CRUDError) -> Void){
        fetchRequest.predicate = NSPredicate(format: "title=%@", title)
        do {
            let result = try fetchFromTheDB(fetchRequest: fetchRequest)
            guard let bookToDelete = result[0] as? Book  else {
                print("Unable to find the book in the list!")
                return
            }
            dataManager.persistentContainer.viewContext.delete(bookToDelete)
            dataManager.saveContext(errorHandler: errorHandler)
        } catch {
            let deletionError = CRUDError(errorType: .deletionError, errorMessage: error.localizedDescription)
            errorHandler(deletionError)
        }
    }
    
    func createManagedObjectBook(errorHandler: (CRUDError) -> Void) -> Book? {
        guard let bookEntity = NSEntityDescription.entity(forEntityName: "Book", in: dataManager.persistentContainer.viewContext) else {
            let creationError = CRUDError(errorType: .creationError, errorMessage: "Failed to create entity for the book")
            errorHandler(creationError)
        }
        let book = Book(entity: bookEntity, insertInto: dataManager.persistentContainer.viewContext)
        return book
    }
}
