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
		renderViewAccordingToLibraryState()
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
	
	// MARK: BookProtocol conformation
	
	//	func performAction(flowState: FlowState,book newBook : Book) {
	//		guard flowState == FlowState.create else {
	//			return
	//		}
	//		books.append(newBook)
	//		tableView.reloadData()
	//	}

}
