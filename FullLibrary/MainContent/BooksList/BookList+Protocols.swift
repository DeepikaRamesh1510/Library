//
//  BookListExtension.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit


extension BooksListViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate ,BookProtocol {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		getTheBooks()
		peformNavigationViewChanges()
		assignDelegatePropertiesValue()
		tableAndKeyboardViewChanges()
	}
	
	func tableAndKeyboardViewChanges() {
		tableView.tableFooterView = UIView()
		tableView.keyboardDismissMode = .onDrag
	}
	
	func assignDelegatePropertiesValue() {
		tableView.dataSource = self
		tableView.delegate = self
		self.searchBar.delegate = self
	}
	
	func peformNavigationViewChanges() {
		self.tabBarController?.navigationItem.title = "Books"
	}
	
	func performUpdateAction(book: Book) {
		guard let indexToBeUpdated = books.firstIndex(where:{ (bookInArray) -> Bool in
			bookInArray.isbn == book.isbn
		}) else {
			return
		}
		books[indexToBeUpdated] = book
		tableView.reloadData()
	}
	
	// MARK: TableViewDelegate methods
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return books.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookTableViewCell
		bookCell.title.text = books[indexPath.item].title
		bookCell.author.text = books[indexPath.item].authorName
		return bookCell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			var isDeleted: Bool = true
			guard let bookISBN = books[indexPath.item].isbn else {
				showToast(message: "Deletion Failed!")
				return
			}
			ManageBooks.shared.deleteBook(isbn: bookISBN) { (error) in
				self.showToast(message: error.errorType.rawValue)
				isDeleted = false
				return
			}
			guard isDeleted else {
				return
			}
			self.books.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
			print(indexPath.item)
			
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let bookDetailViewController = storyboard?.instantiateViewController(withIdentifier: "BookDetailViewController") as? BookDetailViewController else {
			print("Failed to open instantiate book detail view controller")
			return
		}
		bookDetailViewController.book = books[indexPath.item]
		bookDetailViewController.bookUpdationDelegate = self
		navigationController?.pushViewController(bookDetailViewController, animated: true)
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	// MARK: BookProtocol conformation
	
	func performAction(flowState: FlowState,book newBook : Book) {
		guard flowState == FlowState.create else {
			return
		}
		books.append(newBook)
		tableView.reloadData()
	}
	
	// MARK: search bar operations
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard searchText.length > 0  else {
			return
		}
		fetchBooks(bySearch: self.searchText) { (data,error) in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else {
				print("Data not received!")
				return
			}
			let xmlResponseParser = XMLResponseParser()
			self.books = xmlResponseParser.parseTheXMLData(xmlData: data)
			self.tableView.reloadData()
		}
		self.searchBar.endEditing(true)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.searchText = searchText
//		if searchText.isEmpty {
//		} else {
//			fetchBooks(bySearch: searchText) { (data,error) in
//				if let error = error {
//					print(error.localizedDescription)
//					return
//				}
//				guard let data = data else {
//					print("Data not received!")
//					return
//				}
//				let xmlResponseParser = XMLResponseParser()
//				self.books = xmlResponseParser.parseTheXMLData(xmlData: data)
//				self.tableView.reloadData()
//			}
//		}
	}
	
	//MARK: fetching books list from the goodsReads server
	func fetchBooks(bySearch searchString: String, completionHandler: @escaping (Data?, Error?) -> Void) {
		GoodReadsNetworkRequest.shared.fetchBooks(bySearch: searchString, completionHandler: completionHandler)
	}
	
}
