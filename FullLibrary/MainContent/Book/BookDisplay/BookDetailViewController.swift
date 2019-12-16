//
//  BookDetailViewController.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController, BookUpdationProtocol {
	
	@IBOutlet var bookTitle: UILabel!
	@IBOutlet var author: UILabel!
	@IBOutlet var synopsis: UITextView!
	@IBOutlet var genreAndNoOfPages: UILabel!
	var myLibraryBook: Book?
	var goodReadsBook: GoodReadsBook?
	var libraryState: LibraryState = .myLibrary
	var bookUpdationDelegate: BookUpdationProtocol?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		performNavigationBarViewChanges()
		updatePageWithContents()
	}
	
	func checkForSynopsis() {
		var bookId: String
		if libraryState == .myLibrary {
			guard let synopsisOfBook = myLibraryBook?.synopsis, synopsisOfBook.length > 0 else {
				return
			}
			bookId = myLibraryBook?.bookId ?? ""
		} else {
			guard let synopsis = goodReadsBook?.synopsis, synopsis.length > 0 else {
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
			self.synopsis.text = xmlParser.parseSynopsis(xmlData: data)
		}
	}
	
	func performNavigationBarViewChanges() {
		let updateImage = UIImage(named: ImageAssets.pencil.rawValue)
		let updateButton = UIBarButtonItem(image: updateImage, style: .plain, target: self, action: #selector(presentUpdateViewController(_:)))
		navigationController?.changeNavigationBarContent(target: self,title: "Book", rightBarButton: updateButton)
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
		//		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		//		appDelegate?.floatingButtonController?.isVisible = false
		present(bookViewController, animated: true, completion: nil)
	}
	func performUpdateAction(book: Book) {
		self.myLibraryBook = book
		updatePageWithContents()
		bookUpdationDelegate?.performUpdateAction(book: book)
	}
	
	func updatePageWithContents() {
		
		libraryState == .myLibrary ? updateBookDetails(title: myLibraryBook?.title, author: myLibraryBook?.authorName, synopsis: myLibraryBook?.synopsis) : updateBookDetails(title: goodReadsBook?.title, author: goodReadsBook?.authorName, synopsis: goodReadsBook?.synopsis)
		//		bookTitle.text = book?.title
		//		author.text = book?.authorName
		//		synopsis.text = book?.synopsis ?? "Sysnopsis is not provided for this book"
		//		let genre = (book?.genre ?? "" ).isEmpty ? "Genre not specicfied" : book?.genre!
		//		let noOfPages = book?.noOfPages ?? 0
		//		if let genre = book?.genre, genre.isNotEmpty {
		//			genreAndNoOfPages.text = "\(genre) | \(noOfPages) Pages"
		//		} else {
		//			 genreAndNoOfPages.text = "Genre not specicfied | \(noOfPages) Pages"
		//		}
		
	}
	
	func updateBookDetails(title: String?, author: String?, synopsis: String?) {
		self.bookTitle.text = title
		self.author.text = author
		self.synopsis.text = synopsis
	}
}
