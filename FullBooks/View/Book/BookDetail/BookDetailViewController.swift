//
//  BookDetailViewController.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
	
	@IBOutlet var addBookButton: UIButton!
	@IBOutlet weak var bookImage: UIImageView!
	@IBOutlet weak var bookTitle: UILabel!
	@IBOutlet weak var author: UILabel!
	@IBOutlet weak var synopsis: UITextView!
	@IBOutlet weak var genreAndNoOfPages: UILabel!
	@IBOutlet weak var numberOfBooks: UITextField!
	@IBOutlet weak var numberOfBooksStepper: UIStepper!
	var fullBooksViewModel: FullBooksViewModel!
	var goodReadsBooksViewModel: GoodReadsBooksViewModel!
	var myLibraryBook: Book?
	var goodReadsBook: GoodReadsBook?
	var libraryState: LibraryState = .myLibrary
	
	override func viewDidLoad() {
		super.viewDidLoad()
		initializeFullLibraryViewModel()
		setNavigationBarTitle()
		modifyViewAccordingToLibraryState()
		checkForSynopsis()
	}
	
	func configureStepper() {
		numberOfBooksStepper.minimumValue = 1
		numberOfBooksStepper.autorepeat = true
		numberOfBooksStepper.wraps = true
	}
	
	func initializeFullLibraryViewModel() {
		let rootNavigationController = self.navigationController as! RootNavigationController
		fullBooksViewModel = FullBooksViewModel(coreDataManager: rootNavigationController.coreDataManager)
		goodReadsBooksViewModel = GoodReadsBooksViewModel(coreDataManager: rootNavigationController.coreDataManager, networkManager: rootNavigationController.networkManager)
	}
	
	@IBAction func addBooksToLibrary(_ sender: Any) {
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
		if fullBooksViewModel.isBookAvailable(bookId: goodReadsBook.bookId) {
			let okAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
			self.showAlert(title: "Alert", message: "A book with same BookID already exists!", actions: [okAlertAction])
			return
		}
		fullBooksViewModel.insertNewBook(title: goodReadsBook.title, author: goodReadsBook.authorName, bookId: goodReadsBook.bookId, noOfPages: 0, synopsis: goodReadsBook.synopsis, genre: nil, imageData: goodReadsBook.image, rating: goodReadsBook.rating, numberOfCopies: numberOfCopies) { (error) in
			guard let error = error else {
				self.showToast(message: "Book added to library!")
				self.navigationController?.popViewController(animated: true)
				return
			}
			self.showToast(message: error.errorType.rawValue)
		}
	}
	func checkForSynopsis() {
		var bookId: String
		synopsis.displayLoadingSpinner()
		if libraryState == .myLibrary {
			if let synopsisOfBook = myLibraryBook?.synopsis, synopsisOfBook.length > 0  {
				return
			}
			bookId = myLibraryBook?.bookId ?? ""
		} else {
			if let synopsisContent = goodReadsBook?.synopsis, synopsisContent.length > 0 {
				return
			}
			bookId = goodReadsBook?.bookId ?? ""
		}
		guard bookId.length > 0 else {
			return
		}
		goodReadsBooksViewModel.fetchSynopsis(bookId: bookId) { (data,error) in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else {
				print("Data not received!")
				return
			}
			let xmlParser = XMLResponseParser()
			let synopsisContent = xmlParser.parseSynopsis(xmlData: data)
			self.synopsis.text = synopsisContent.length > 5 ? synopsisContent : "Synopsis is not available!"
			if self.libraryState == .myLibrary {
				self.myLibraryBook?.synopsis = synopsisContent
				self.fullBooksViewModel.updateBookContent()
			} else {
				self.goodReadsBook?.synopsis = synopsisContent
			}
				self.synopsis.removeLoaderFromDisplay()
		}
	}
	
	func setNavigationBarTitle() {
		var navBarTitle = ""
		if let bookTitle = libraryState == .myLibrary ? myLibraryBook?.title : goodReadsBook?.title {
			navBarTitle = bookTitle
		}
		navBarTitle = navBarTitle.length > 0 ? navBarTitle : "Book Detail"
		navigationItem.title = navBarTitle
	}
	
	func checkForAnyChanges() -> Bool {
		return fullBooksViewModel.checkForChanges()
	}
	
	func modifyViewAccordingToLibraryState() {
		libraryState == .myLibrary ? updateBookDetails(title: myLibraryBook?.title, author: myLibraryBook?.authorName, synopsis: myLibraryBook?.synopsis, numberOfBooks: myLibraryBook?.noOfCopies,imageData: myLibraryBook?.image) : updateBookDetails(title: goodReadsBook?.title, author: goodReadsBook?.authorName, synopsis: goodReadsBook?.synopsis, numberOfBooks: goodReadsBook?.noOfCopies, imageData: goodReadsBook?.image)
		self.numberOfBooksStepper.isHidden =  libraryState == .myLibrary ? true : false
		self.numberOfBooksStepper.isEnabled = libraryState == .myLibrary ? false : true
		self.numberOfBooks.isEnabled = libraryState == .myLibrary ? false : true
		self.addBookButton.isEnabled = libraryState == .myLibrary ? false : true
		self.addBookButton.isHidden =  libraryState == .myLibrary ? true : false
	}
	
	@IBAction func changeTheBooksCount(_ sender: UIStepper) {
		numberOfBooks.text = Int(numberOfBooksStepper.value).description
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
	

}
