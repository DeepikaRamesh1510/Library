//
//  BookDetailViewController.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController, BookUpdationProtocol {
	
	//	@IBOutlet var addToLibraryButtonContainer: UIView!
	@IBOutlet weak var bookImage: UIImageView!
	@IBOutlet weak var bookTitle: UILabel!
	@IBOutlet weak var author: UILabel!
	@IBOutlet weak var synopsis: UITextView!
	@IBOutlet weak var genreAndNoOfPages: UILabel!
	@IBOutlet weak var numberOfBooks: UITextField!
	@IBOutlet weak var numberOfBooksStepper: UIStepper!
	var myLibraryBook: Book?
	var goodReadsBook: GoodReadsBook?
	var libraryState: LibraryState = .myLibrary
	var bookUpdationDelegate: BookUpdationProtocol?
	var booksManager: BooksManager?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		performNavigationBarViewChanges()
		updatePageWithContents()
		checkForSynopsis()
		numberOfBooksStepper.minimumValue = 1
		initializeTheBookManager()
	}
	
	func initializeTheBookManager() {
		guard let rootNavigationController = self.navigationController as? RootNavigationController else {
			print("rootNavigationController not available!")
			return
		}
		booksManager = BooksManager(dataManager: rootNavigationController.dataManager)
	}
	
	@IBAction func addBooksToLibrary(_ sender: Any) {
		guard let booksManager = booksManager else {
			print("Bookk manager is not initialized !")
			return
		}
		guard let goodReadsBook = goodReadsBook else {
			print("Didn't receive a good read book!")
			return
		}
		guard let numberOfCopiesString = numberOfBooks.text, let numberOfCopies = numberOfCopiesString.toInt16, numberOfCopies > 0 else {
			let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
			self.showAlert(title: "Alert", message: "The number of copies should always be greater than 1", actions: [okAction])
			return
		}
		// checking whether the book is already available
		if booksManager.isBookAvailable(bookId: goodReadsBook.bookId) {
			let okAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
			self.showAlert(title: "Alert", message: "A book with same BookID already exists!", actions: [okAlertAction])
			return
		}
		booksManager.insertNewBook(title: goodReadsBook.title, author: goodReadsBook.authorName, bookId: goodReadsBook.bookId, noOfPages: 0, synopsis: goodReadsBook.synopsis, genre: nil, imageData: goodReadsBook.image, rating: goodReadsBook.rating, numberOfCopies: numberOfCopies) { (error) in
			guard let error = error else {
				self.showToast(message: "Book added to library!")
				self.dismissViewController()
				return
			}
			self.showToast(message: error.errorType.rawValue)
		}
	}
	func checkForSynopsis() {
		var bookId: String
		if libraryState == .myLibrary {
			if let synopsisOfBook = myLibraryBook?.synopsis, synopsisOfBook.length > 0  {
				return
			}
			bookId = myLibraryBook?.bookId ?? ""
		} else {
			if let synopsis = goodReadsBook?.synopsis, synopsis.length > 0 {
				return
			}
			bookId = goodReadsBook?.bookId ?? ""
		}
		guard bookId.length > 0 else {
			return
		}
		GoodReadsNetworkRequest.shared.fetchSynopsis(bookId: bookId) { (data,error) in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else {
				print("Data not received!")
				return
			}
			let xmlParser = XMLResponseParser()
			//			DispatchQueue.main.async {
			self.synopsis.text = xmlParser.parseSynopsis(xmlData: data)
			//			}
			
		}
	}
	
	func performNavigationBarViewChanges() {
		var updateButton: UIBarButtonItem?
		if libraryState == .myLibrary {
			let updateImage = UIImage(named: ImageAssets.pencil.rawValue)
			updateButton = UIBarButtonItem(image: updateImage, style: .plain, target: self, action: #selector(presentUpdateViewController(_:)))
		}
		let navigationTitle = libraryState == .myLibrary ? myLibraryBook?.title : goodReadsBook?.title
		navigationController?.changeNavigationBarContent(target: self,title: navigationTitle ?? "Book Detail", rightBarButton: updateButton)
	}
	func checkForAnyChanges() -> Bool {
		guard let booksManager = booksManager else {
			print("book manager is not initialized!")
			return false
		}
		return booksManager.checkForChanges()
	}
	
	@objc func presentUpdateViewController(_ sender: UIBarButtonItem) {
		guard let bookViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.bookViewController.rawValue) as? BookViewController else {
			print("Failed to instatiate book view Controller")
			return
		}
		guard let staticTable = storyboard?.instantiateViewController(withIdentifier: ViewController.bookTableViewController.rawValue) as? BookStaticTableViewController else {
			print("Failed to instantiate static table content viwe controller")
			return
		}
		staticTable.book = myLibraryBook
		staticTable.flowState = .update
		staticTable.bookUpdationDelegate = self
		present(bookViewController, animated: true, completion: nil)
	}
	func performUpdateAction(book: Book) {
		self.myLibraryBook = book
		updatePageWithContents()
		bookUpdationDelegate?.performUpdateAction(book: book)
	}
	
	func updatePageWithContents() {
		libraryState == .myLibrary ? updateBookDetails(title: myLibraryBook?.title, author: myLibraryBook?.authorName, synopsis: myLibraryBook?.synopsis, numberOfBooks: myLibraryBook?.noOfCopies,imageData: myLibraryBook?.image) : updateBookDetails(title: goodReadsBook?.title, author: goodReadsBook?.authorName, synopsis: goodReadsBook?.synopsis, numberOfBooks: goodReadsBook?.noOfCopies, imageData: goodReadsBook?.image)
		
	}
	
	func updateBookDetails(title: String?, author: String?, synopsis: String?, numberOfBooks: Int16?, imageData: Data?) {
		self.bookTitle.text = title
		self.author.text = author
		self.synopsis.text = synopsis
		self.numberOfBooks.text = String(numberOfBooks ?? 1)
		if let imageData = imageData {
			self.bookImage.image = UIImage(data: imageData)
		} else {
			self.bookImage.image = UIImage(named: "book")
		}
		
	}
	
	
//	@IBAction func stepperClicked(_ sender: Any) {
//		numberOfBooksStepper.
//	}
}
