//
//  BookListExtension.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit

//,BookProtocol -> removed the book protocol in
extension BooksListViewController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		peformNavigationViewChanges()
		assignDelegatePropertiesValue()
		tableAndKeyboardViewChanges()
		renderingSearchBar()
		renderingSegmentedControl()
		renderViewAccordingToLibraryState()
	}
	
	func renderingSegmentedControl() {
		if #available(iOS 13.0, *) {
			segmentedControl.selectedSegmentTintColor = UIColor.systemYellow
		}
		segmentedControl.tintColor = UIColor.systemYellow

	}
	
	func renderViewAccordingToLibraryState() {
		if libraryState == .myLibrary {
			getTheBooks()
		}
	}
	
	func tableAndKeyboardViewChanges() {
		tableView.tableFooterView = UIView()
		tableView.keyboardDismissMode = .onDrag
	}
	
	func renderingSearchBar() {
		self.searchBar.image(for: .search, state: .normal)
		self.searchBar.delegate = self
	}
	
	func assignDelegatePropertiesValue() {
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	func peformNavigationViewChanges() {
		self.tabBarController?.navigationItem.title = "Books"
	}
	
//		func performUpdateAction(book: Book) {
//			guard let indexToBeUpdated = myLibraryBooks.firstIndex(where:{ (bookInArray) -> Bool in
//	//			bookInArray.isbn == book.isbn
//			}) else {
//				return
//			}
//			myLibraryBooks[indexToBeUpdated] = book
//			tableView.reloadData()
//		}
	
	
	
	// MARK: TableViewDelegate methods
	
	
	// MARK: BookProtocol conformation
	
	//	func performAction(flowState: FlowState,book newBook : Book) {
	//		guard flowState == FlowState.create else {
	//			return
	//		}
	//		books.append(newBook)
	//		tableView.reloadData()
	//	}
	
	// MARK: search bar operations
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard searchText.length > 0  else {
			return
		}
		if libraryState == .goodReads {
			fetchBooksInGoodReadsLibrary(bySearch: self.searchText)
		} else {
			fetchBooksInMyLibrary(bySearch: searchText)
		}
		
		self.searchBar.endEditing(true)
	}
	
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		self.searchText = searchText
		if libraryState == .myLibrary {
			fetchBooksInMyLibrary(bySearch: searchText)
		}
		
	}
	
	//MARK: fetching books list from the goodsReads server
	func fetchBooksInGoodReadsLibrary(bySearch searchString: String) {
		GoodReadsNetworkRequest.shared.fetchBooks(bySearch: searchString) { (data,error) in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else {
				print("Data not received!")
				return
			}
			let xmlResponseParser = XMLResponseParser()
			self.goodReadsBooks = xmlResponseParser.parseTheXMLData(xmlData: data)
			self.tableView.reloadData()
		}
	}
	
	//MARK: fetching books from my library
	
	func fetchBooksInMyLibrary(bySearch: String) {
		if searchText.isEmpty {
			guard let allBooks = ManageBooks.shared.fetchBooks() else {
				return
			}
			self.myLibraryBooks = allBooks
		} else {
			self.myLibraryBooks = ManageBooks.shared.fetchBooksBasedOnSearch(by: searchText)
		}
		self.tableView.reloadData()
	}
	
}
