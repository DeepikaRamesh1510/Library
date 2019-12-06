
//
//  BoooksListViewController.swift
//  FullLibrary
//
//  Created by user on 04/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BooksListViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    var books = [Book]()
    
    func getTheBooks(){
        guard let result = ManageBooks.shared.fetchBooks() else {
            print("Unable to fetch data!")
            return
        }
        for book in result {
            guard let book = book as? Book else {
                continue
            }
            books.append(book)
        }
    }

    @objc func presentBookCreationViewController(_ sender: UIBarButtonItem) {
        guard let bookCreationViewController = storyboard?.instantiateViewController(withIdentifier: "BookCreationViewController") as? BookCreationViewController else {
            print("Failed to instatiate book creation view Controller")
            return
        }
        bookCreationViewController.addBookToListDelegate = self
        present(bookCreationViewController, animated: true, completion: nil)
    }
    
}

