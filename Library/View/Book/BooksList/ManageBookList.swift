//
//  ManageBookList.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ManageBookList {
    lazy var dataManager = DataManager()
    func fetchBookList(){
        let fetchBookRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Booklist")
        do {
            let result = try dataManager.persistentContainer.viewContext.fetch(fetchBookRequest)
        }
        catch {
            print(error)
        }
    }
}
