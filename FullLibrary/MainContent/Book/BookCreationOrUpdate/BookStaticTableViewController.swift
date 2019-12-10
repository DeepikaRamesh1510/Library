//
//  BookViewController.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookStaticTableViewController: UITableViewController {
	
	@IBOutlet var synopsis: UITextField!
	@IBOutlet var noOfPages: UITextField!
	@IBOutlet var genre: UITextField!
	@IBOutlet var isbnTextField: UITextField!
	@IBOutlet var author: UITextField!
	@IBOutlet var bookTitle: UITextField!
	
	weak var addBookToListDelegate: BookProtocol?
	weak var bookUpdationDelegate: BookUpdationProtocol?
	var flowState: FlowState = .create
	var book: Book?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		renderPageBasedFlowState()
//		customizeFooterContent()
	}
	
	// MARK: Header and Footer Customization
	func customizeFooterContent() {
		let footerOrigin = CGPoint(x: 0, y: view.frame.height - 60)
		let footerSize = CGSize(width: view.frame.width, height: 60)
		let footerRect = CGRect(origin: footerOrigin, size: footerSize)
		let footer = UIView(frame: footerRect)
		let cancelButton = createCancelButton(in: footer)
		let saveButton = createSaveButton(in: footer)
		footer.addSubview(cancelButton)
		footer.addSubview(saveButton)
		tableView.tableFooterView = footer
	}
	
	func createCancelButton(in footer: UIView) -> UIButton {
		let cancelButtonOrigin = CGPoint(x: footer.bounds.minX + 30, y: footer.bounds.minY + 10)
		let cancelButtonSize = CGSize(width: 100, height: 40)
		let cancelButtonRect = CGRect(origin: cancelButtonOrigin, size: cancelButtonSize)
		let cancelButton = UIButton(frame: cancelButtonRect)
		cancelButton.setTitle("Cancel", for: .normal)
		cancelButton.setTitleColor(UIColor.white, for: .normal)
		cancelButton.backgroundColor = UIColor.systemRed
		cancelButton.addTarget(self, action: #selector(closeModal(_:)), for: .touchUpInside)
		return cancelButton
	}
	
	func createSaveButton(in footer: UIView) -> UIButton {
		let saveButtonOrigin = CGPoint(x: footer.frame.width - 130, y: footer.bounds.minY + 10)
		let saveButtonSize = CGSize(width: 100, height: 40)
		let saveButtonRect = CGRect(origin: saveButtonOrigin, size: saveButtonSize)
		let saveButton = UIButton(frame: saveButtonRect)
		saveButton.setTitle("Save", for: .normal)
		saveButton.setTitleColor(UIColor.black, for: .normal)
		saveButton.backgroundColor = UIColor.systemYellow
		saveButton.addTarget(self, action: #selector(saveBookDetails(_:)), for: .touchUpInside)
		return saveButton
	}
	
	func customizeHeaderContent(title: String) {
		let headerOrigin = CGPoint(x: 0, y: 0)
		let headerSize = CGSize(width: view.frame.width, height: 70)
		let headerRect = CGRect(origin: headerOrigin, size: headerSize)
		let header = UIView(frame: headerRect)
		let headerTitle = createHeaderTitle(title: title, header: header)
		let closeButton = createCloseButton(header: header)
		header.addSubview(headerTitle)
		header.addSubview(closeButton)
		header.backgroundColor = UIColor.systemYellow
		tableView.tableHeaderView = header
	}
	
	func createHeaderTitle(title: String,header: UIView) -> UILabel {
		let headerTitleRect = CGRect(x: 0, y: 0, width: 100, height: 40)
		let headerTitle = UILabel(frame: headerTitleRect)
		headerTitle.center = header.center
		headerTitle.text = title
		return headerTitle
	}
	
	func createCloseButton(header: UIView) -> UIButton {
		let closeButtonOrigin = CGPoint(x: header.frame.width - 60, y: 0)
		let closeButtonSize = CGSize(width: 60, height: 60)
		let closeButtonRect = CGRect(origin: closeButtonOrigin, size: closeButtonSize)
		let closeButton = UIButton(frame: closeButtonRect)
		let closeImage = UIImage(named: ImageAssets.close.rawValue)
		closeButton.setImage(closeImage, for: .normal)
		closeButton.center.y = header.center.y
		closeButton.addTarget(self, action: #selector(closeModal(_:)), for: .touchUpInside)
		return closeButton
	}
	
	func renderPageBasedFlowState() {
		guard flowState == FlowState.update else {
			customizeHeaderContent(title: "New Book")
			return
		}
		self.isbnTextField.isUserInteractionEnabled = false
		self.isbnTextField.backgroundColor = UIColor.systemGray
		customizeHeaderContent(title: "Update Book")
		guard let bookToBeUpdated = book else {
			return
		}
		bookTitle.text = bookToBeUpdated.title
		author.text = bookToBeUpdated.authorName
		noOfPages.text = String(bookToBeUpdated.noOfPages)
		synopsis.text = bookToBeUpdated.synopsis
		genre.text = bookToBeUpdated.genre
		isbnTextField.text = bookToBeUpdated.isbn
	}
	
	@objc func closeModal(_ sender: Any) {
		self.dismissViewController()
	}

	// MARK: Save book details into coredata
	@objc func saveBookDetails(_ sender: Any) {
		guard let bookTitle = bookTitle.text, let author = author.text, let isbn = isbnTextField.text, bookTitle.isNotEmpty, author.isNotEmpty, isbn.isNotEmpty else {
			let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			self.showAlert(title: "Alert", message: "ISBN, title & author are mandatory!", actions: [okAlertAction])
			print("Unable to unwrap the book details!")
			return
		}
		if flowState == .create {
			// checking whether the book is already available
			if ManageBooks.shared.isBookAvailable(isbn: isbn) {
				let okAlertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
				self.showAlert(title: "Alert", message: "A book with same ISBN already exists!", actions: [okAlertAction])
				isbnTextField.text = ""
				return
			}
			
			// creating a new book if not available
			guard let newBook = ManageBooks.shared.insertNewBook(title: bookTitle, author: author, isbn: isbn, noOfPages: noOfPages.text.toInt16 , synopsis: synopsis?.text, genre: genre?.text,errorHandler: { (error) in
				self.showToast(message: error.errorType.rawValue)
			}) else {
				self.showToast(message: "Creation Failed!")
				return
			}
			addBookToListDelegate?.performAction(flowState: .create, book: newBook)
		} else {
			updateBookDetails()
			ManageBooks.shared.dataManager.saveContext() { (error) in
				self.showToast(message: error.errorType.rawValue)
			}
		}
		self.dismissViewController()
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
