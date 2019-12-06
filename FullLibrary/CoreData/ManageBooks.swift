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
    func insertNewBook(book: Book,completionHandler: (NSError) -> Void ) {
        dataManager.saveContext(completionHandler: completionHandler)
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
    
    func deleteBook(title: String,completionHandler: (NSError) -> Void){
        fetchRequest.predicate = NSPredicate(format: "title=%@", title)
        do {
            let result = try fetchFromTheDB(fetchRequest: fetchRequest)
            guard let bookToDelete = result[0] as? Book  else {
                print("Unable to find the book in the list!")
                return
            }
            dataManager.persistentContainer.viewContext.delete(bookToDelete)
            dataManager.saveContext(completionHandler: completionHandler)
        } catch {
            print(error)
        }
    }
    
    func createManagedObjectBook() -> Book? {
        let bookEntity = NSEntityDescription(
        let book = Book(entity: <#T##NSEntityDescription#>, insertInto: dataManager.persistentContainer.viewContext)
    }
}
