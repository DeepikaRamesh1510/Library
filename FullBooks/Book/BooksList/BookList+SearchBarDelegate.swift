//
//  BookList+SearchBarHelper.swift
//  FullLibrary
//
//  Created by user on 16/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension BooksListViewController: UISearchBarDelegate {
	
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
		self.currentPage = 1
		clearBookContentsInList()
		if libraryState == .myLibrary {
			fetchBooksInMyLibrary(bySearch: searchText)
		} 
		
	}
}
