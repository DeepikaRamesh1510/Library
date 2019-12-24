
//
//  BoooksListViewController.swift
//  FullLibrary
//
//  Created by user on 04/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BooksListViewController: UIViewController {
	
	@IBOutlet weak var searchBar: UISearchBar!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segmentedControl: UISegmentedControl!
	var fullBooksViewModel: FullBooksViewModel!
	var goodReadsBooksViewModel: GoodReadsBooksViewModel!
	var goodReadsBooks = [GoodReadsBook]()
	var myLibraryBooks = [Book]()
	var libraryState: LibraryState = .myLibrary
	var searchText = ""
	var currentPage : Int = 1
	var isLoadingList : Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configuringNavigationBar()
		configuringTableView()
		initializeTheBookManager()
		assignDelegatePropertiesValue()
		getTheBooks()
	}
	
	func initializeTheBookManager() {
		let rootNavigationController = self.navigationController as! RootNavigationController
		fullBooksViewModel = FullBooksViewModel(coreDataManager: rootNavigationController.coreDataManager)
		fullBooksViewModel.delegate = self
		goodReadsBooksViewModel = GoodReadsBooksViewModel(coreDataManager: rootNavigationController.coreDataManager, networkManager: rootNavigationController.networkManager)
		goodReadsBooksViewModel.delegate = self
	}
	
	func getTheBooks(){
		fullBooksViewModel.fetchBooks()
	}
	
	func clearSearchBarContent() {
		self.searchBar.text = ""
		self.searchText = ""
	}
	
	@IBAction func libraryChanged(_ sender: Any) {
		clearSearchBarContent()
//		clearBookContentsInList()
		switch segmentedControl.selectedSegmentIndex {
			case 0:
				libraryState = .goodReads
				clearFullLibraryBooksContent()
			case 1:
				clearGoodReadsBooksContent()
				libraryState = .myLibrary
				getTheBooks()
			default:
				print("Nothing is selected")
		}
	}
	
	func clearGoodReadsBooksContent() {
		self.goodReadsBooks = []
		tableView.reloadData()
	}
	
	func clearFullLibraryBooksContent() {
		self.myLibraryBooks = []
		tableView.reloadData()
	}
	
	//MARK: fetching books list from the goodsReads server
	func getGoodReadsBooks(bySearch searchString: String) {
		goodReadsBooksViewModel.fetchBooks(bySearch: searchString, pageNumber: currentPage) 
	}
	
	//MARK: fetching books from my library
	
	func getFullLibraryBooks(bySearch: String) {
		if searchText.isEmpty {
			fullBooksViewModel.fetchBooks()
		} else {
			fullBooksViewModel.fetchBooksBasedOnSearch(by: searchText)
		}
		self.tableView.reloadData()
	}
	
	//MARK: Modifying the UI for the BookList
	func configuringTableView() {
		tableView.setTableViewFooter()
		tableView.dismissTableViewOnDrag()
	}
	
	func configuringNavigationBar() {
		tabBarController?.navigationItem.title = "Books"
	}
	
	//MARK: Assigning self to all the conformed delegates
	func assignDelegatePropertiesValue() {
		tableView.dataSource = self
		tableView.delegate = self
		searchBar.delegate = self
		fullBooksViewModel.delegate = self
		goodReadsBooksViewModel.delegate = self
	}
	
	
}
