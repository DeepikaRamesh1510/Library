
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
	@IBOutlet var segmentedControl: UISegmentedControl!
	var goodReadsBooks = [GoodReadsBook]()
	var myLibraryBooks = [Book]()
	var libraryState: LibraryState = .myLibrary
	//	var books = [Any]()
	var xmlParser: XMLParser?
	var searchText = ""
	
	func getTheBooks(){
		guard let result = ManageBooks.shared.fetchBooks() else {
			print("Unable to fetch data!")
			return
		}
		self.myLibraryBooks = result
	}
	@objc func presentBookCreationViewController(_ sender: UIBarButtonItem) {
		
		guard let bookViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.bookViewController.rawValue) as? BookViewController else {
			print("Failed to instatiate book view Controller")
			return
		}
		present(bookViewController, animated: true, completion: nil)
	}
	
	func changeSelectedSegmentColor() {
		if #available(iOS 13.0, *) {
			segmentedControl.selectedSegmentTintColor = UIColor.systemYellow
			//return
		}
		segmentedControl?.tintColor = UIColor.systemYellow
	}
	
	func clearSearchBarContent() {
		self.searchBar.text = ""
		self.searchText = ""
	}
	
	@IBAction func libraryChanged(_ sender: Any) {
		clearSearchBarContent()
		switch segmentedControl.selectedSegmentIndex {
			case 0:
				libraryState = .goodReads
			case 1:
				libraryState = .myLibrary
				getTheBooks()
			default:
				print("Nothing is selected")
		}
		
		self.tableView.reloadData()
	}
}

