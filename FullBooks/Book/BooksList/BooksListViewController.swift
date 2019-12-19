
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
	var booksManager: BooksManager?
	var goodReadsBooks = [GoodReadsBook]()
	var myLibraryBooks = [Book]()
	var libraryState: LibraryState = .myLibrary
	var xmlParser: XMLParser?
	var searchText = ""
	var currentPage : Int = 1
	var isLoadingList : Bool = false
	
	override func viewDidLoad() {
		super.viewDidLoad()
		peformNavigationViewChanges()
		assignDelegatePropertiesValue()
		tableAndKeyboardViewChanges()
		renderingSearchBar()
		renderViewAccordingToLibraryState()
		
	}
	
	func initializeTheBookManager() {
		guard let rootNavigationController = self.navigationController as? RootNavigationController else {
			print("rootNavigationController not available!")
			return
		}
		booksManager = BooksManager(dataManager: rootNavigationController.dataManager)
	}
	
	func getTheBooks(){
		guard let result = booksManager?.fetchBooks() else {
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
	func clearSearchBarContent() {
		self.searchBar.text = ""
		self.searchText = ""
	}
	
	@IBAction func libraryChanged(_ sender: Any) {
		clearSearchBarContent()
		clearBookContentsInList()
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
	
	func clearBookContentsInList() {
		self.myLibraryBooks = []
		self.goodReadsBooks = []
	}
	
	//MARK: fetching books list from the goodsReads server
	func fetchBooksInGoodReadsLibrary(bySearch searchString: String) {
		GoodReadsNetworkRequest.shared.fetchBooks(bySearch: searchString, pageNumber: currentPage) { (data,error) in
			self.tableView.tableFooterView = UIView()
			self.isLoadingList = false
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else {
				print("Data not received!")
				return
			}
			let xmlResponseParser = XMLResponseParser()
			self.goodReadsBooks += xmlResponseParser.parseTheXMLData(xmlData: data)
			self.currentPage += 1
			self.tableView.reloadData()
		}
	}
	
	//MARK: fetching books from my library
	
	func fetchBooksInMyLibrary(bySearch: String) {
		if searchText.isEmpty {
			guard let allBooks = booksManager?.fetchBooks() else {
				return
			}
			self.myLibraryBooks = allBooks
		} else {
			
			guard let books = booksManager?.fetchBooksBasedOnSearch(by: searchText) else {
				print("Unable to fetch the books!")
				return
			}
			self.myLibraryBooks += books
		}
		self.tableView.reloadData()
	}
	
}

