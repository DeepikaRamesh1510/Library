//
//  BookList+SearchBarHelper.swift
//  FullLibrary
//
//  Created by user on 16/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension BooksListViewController {
	
	//MARK: searchBar delegate methods
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
