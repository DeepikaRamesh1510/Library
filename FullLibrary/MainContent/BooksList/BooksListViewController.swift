
//
//  BoooksListViewController.swift
//  FullLibrary
//
//  Created by user on 04/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BooksListViewController: UIViewController {
    
	@IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
	var books = [Book]()
	var xmlParser: XMLParser?
	var goodReadBooks = [GoodReadsBook]()
	var goodReadBook = GoodReadsBook()
	var foundCharacters = ""
    func getTheBooks(){
        guard let result = ManageBooks.shared.fetchBooks() else {
            print("Unable to fetch data!")
            return
        }
		self.books = result
    }

    @objc func presentBookCreationViewController(_ sender: UIBarButtonItem) {
        guard let bookViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.bookViewController.rawValue) as? BookViewController else {
            print("Failed to instatiate book view Controller")
            return
        }
        bookViewController.addBookToListDelegate = self
        present(bookViewController, animated: true, completion: nil)
    }
    
}

