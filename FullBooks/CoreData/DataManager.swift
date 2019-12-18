//
//  DataController.swift
//  FullLibrary
//
//  Created by user on 04/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "FullBooks")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
                return
            }
        })
        return container
    }()

    
    func saveContext (errorHandler: (CRUDError?)-> Void) {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let crudError = CRUDError(errorType: .persistingError, errorMessage: error.localizedDescription)
                errorHandler(crudError)
            }
        }
    }
    
    
//    implementation of the persistent container
    
    
//    let modalName: String
//    lazy var managerObjectContext: NSManagedObjectContext = {
//        let managerObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        managerObjectContext.persistentStoreCoordinator = self.persistantStoreCoordinator
//        return managerObjectContext
//    }()
//    lazy var managerObjectModel: NSManagedObjectModel = {
//        guard let modelURL = Bundle.main.url(forResource: self.modalName, withExtension: "xcdatamodeld") else {
//            fatalError("Unable to find the data model in the bundle!")
//        }
//        guard let managerObjectModel  = NSManagedObjectModel(contentsOf: modelURL) else {
//            fatalError("Unable to load the data model!!")
//        }
//        return managerObjectModel
//    }()
//    lazy var persistantStoreCoordinator: NSPersistentStoreCoordinator = {
//        NSPersistentStoreCoordinator(managedObjectModel: self.managerObjectModel)
//    let fileManager = FileManager.default
//    let storeName = "\(self.modelName).sqlite"
//
//    let documentsDirectoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//
//    let persistentStoreURL = documentsDirectoryURL.appendingPathComponent(storeName)
//
//    do {
//        try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType,
//                                                          configurationName: nil,
//                                                          at: persistentStoreURL,
//                                                          options: nil)
//    } catch {
//        fatalError("Unable to Load Persistent Store")
//    }
//
//    return persistentStoreCoordinator
//    }()
//    init(modalName: String) {
//        self.modalName = modalName
//    }
}
