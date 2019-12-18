//
//  BookDetailViewController.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController, BookUpdationProtocol {
	
	@IBOutlet var addToLibraryButtonContainer: UIView!
	@IBOutlet var bookImage: UIImageView!
	@IBOutlet var bookTitle: UILabel!
	@IBOutlet var author: UILabel!
	@IBOutlet var synopsis: UITextView!
	@IBOutlet var genreAndNoOfPages: UILabel!
	@IBOutlet var numberOfBooks: UITextField!
	@IBOutlet var numberOfBooksStepper: UIStepper!
	var myLibraryBook: Book?
	var goodReadsBook: GoodReadsBook?
	var libraryState: LibraryState = .myLibrary
	var bookUpdationDelegate: BookUpdationProtocol?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		performNavigationBarViewChanges()
		updatePageWithContents()
		checkForSynopsis()
	}
	
	@IBAction func addBooksToLibrary(_ sender: Any) {
		guard let goodReadsBook = goodReadsBook else {
			print("Didn't receive a good read book!")
			return
		}
		guard let numberOfCopies = numberOfBooks.text?.toInt16, numberOfCopies > 1 else {
			let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
			self.showAlert(title: "Alert", message: "The number of copies should always be greater than 1", actions: [okAction])
			return
		}
		ManageBooks.shared.insertNewBook(title: goodReadsBook.title, author: goodReadsBook.authorName, bookId: goodReadsBook.bookId, noOfPages: 0, synopsis: goodReadsBook.synopsis, genre: nil, imageData: goodReadsBook.image, rating: goodReadsBook.rating, numberOfCopies: numberOfCopies) { (error) in
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
		libraryState == .myLibrary ? updateBookDetails(title: myLibraryBook?.title, author: myLibraryBook?.authorName, synopsis: myLibraryBook?.synopsis,imageData: myLibraryBook?.image) : updateBookDetails(title: goodReadsBook?.title, author: goodReadsBook?.authorName, synopsis: goodReadsBook?.synopsis, imageData: goodReadsBook?.image)
		
	}
	
	func updateBookDetails(title: String?, author: String?, synopsis: String?, imageData: Data?) {
		self.bookTitle.text = title
		self.author.text = author
		self.synopsis.text = synopsis
		if let imageData = imageData {
			self.bookImage.image = UIImage(data: imageData)
		} else {
			self.bookImage.image = UIImage(named: "book")
		}
		
	}
}
