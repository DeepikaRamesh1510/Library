//
//  BookViewController.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookStaticTableViewController: UITableViewController {
	
	@IBOutlet weak var synopsis: UITextView!
	@IBOutlet weak var noOfPages: UITextField!
	@IBOutlet weak var genre: UITextField!
	@IBOutlet weak var isbnTextField: UITextField!
	@IBOutlet weak var author: UITextField!
	@IBOutlet weak var bookTitle: UITextField!
	@IBOutlet weak var noOfCopies: UITextField!
	weak var addBookToListDelegate: BookProtocol?
	weak var bookUpdationDelegate: BookUpdationProtocol?
	var flowState: FlowState = .create
	var book: Book?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		renderPageBasedFlowState()
		tableView.delegate = self
		tableView.tableFooterView = UIView()
	}
	
	func renderPageBasedFlowState() {
//		guard flowState == FlowState.update else {
//			return
//		}
//		self.isbnTextField.isUserInteractionEnabled = false
//		self.isbnTextField.backgroundColor = UIColor.systemGray
//		guard let bookToBeUpdated = book else {
//			return
//		}
//		bookTitle.text = bookToBeUpdated.title
//		author.text = bookToBeUpdated.authorName
//		noOfPages.text = String(bookToBeUpdated.noOfPages)
//		synopsis.text = bookToBeUpdated.synopsis
//		genre.text = bookToBeUpdated.genre
//		isbnTextField.text = bookToBeUpdated.isbn
	}
	
	@objc func closeModal(_ sender: Any) {
		self.dismissViewController()
	}

	// MARK: Save book details into coredata
	@objc func saveBookDetails(_ sender: Any) {
//		guard let bookTitle = bookTitle.text, let author = author.text, let isbn = isbnTextField.text, bookTitle.isNotEmpty, author.isNotEmpty, isbn.isNotEmpty else {
//			let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
//			self.showAlert(title: "Alert", message: "ISBN, title & author are mandatory!", actions: [okAlertAction])
//			print("Unable to unwrap the book details!")
//			return
//		}
//		if flowState == .create {
//			// checking whether the book is already available
//			if ManageBooks.shared.isBookAvailable(isbn: isbn) {
//				let okAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//				self.showAlert(title: "Alert", message: "A book with same ISBN already exists!", actions: [okAlertAction])
//				isbnTextField.text = ""
//				return
//			}
//			
//			// creating a new book if not available
//			guard let newBook = ManageBooks.shared.insertNewBook(title: bookTitle, author: author, isbn: isbn, noOfPages: noOfPages.text.toInt16 , synopsis: synopsis?.text, genre: genre?.text,errorHandler: { (error) in
//				self.showToast(message: error.errorType.rawValue)
//			}) else {
//				self.showToast(message: "Creation Failed!")
//				return
//			}
//			addBookToListDelegate?.performAction(flowState: .create, book: newBook)
//		} else {
//			updateBookDetails()
//			ManageBooks.shared.dataManager.saveContext() { (error) in
//				self.showToast(message: error.errorType.rawValue)
//			}
//		}
//		self.dismissViewController()
	}
	
	func updateBookDetails(){
		guard let book = book, let author = author.text, author.isNotEmpty, let bookTitle = bookTitle.text, bookTitle.isNotEmpty  else {
			let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			self.showAlert(title: "Alert", message: "Title & author are mandatory!", actions: [okAlertAction])
			return
		}
		book.title = bookTitle
		book.authorName = author
		book.noOfPages = noOfPages.text?.toInt16 ?? 0
		book.synopsis = synopsis.text
		bookUpdationDelegate?.performUpdateAction(book: book)
	}
	
}
