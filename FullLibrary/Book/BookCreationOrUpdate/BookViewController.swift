//
//  BookViewController.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookViewController: UITableViewController {
	
	@IBOutlet var synopsis: UITextField!
	@IBOutlet var noOfPages: UITextField!
	@IBOutlet var genre: UITextField!
	@IBOutlet var isbn: UITextField!
	@IBOutlet var author: UITextField!
	@IBOutlet var bookTitle: UITextField!
	
	weak var addBookToListDelegate: BookProtocol?
	var flowState: FlowState = .create
	var book: Book?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		renderPageBasedFlowState()
		customizeFooterContent()
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
		cancelButton.addTarget(self, action: #selector(closeModal(_:)), for: .allTouchEvents)
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
		saveButton.addTarget(self, action: #selector(saveBookDetails(_:)), for: .allTouchEvents)
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
		closeButton.addTarget(self, action: #selector(closeModal(_:)), for: .allTouchEvents)
		return closeButton
	}
	
	func renderPageBasedFlowState() {
		guard flowState == FlowState.update else {
			customizeHeaderContent(title: "New Book")
			return
		}
		customizeHeaderContent(title: "Update Book")
		guard let bookToBeUpdated = book else {
			return
		}
		bookTitle.text = bookToBeUpdated.title
		author.text = bookToBeUpdated.authorName
		noOfPages.text = String(bookToBeUpdated.noOfPages)
		synopsis.text = bookToBeUpdated.synopsis
		genre.text = bookToBeUpdated.genre
	}
	
	@objc func closeModal(_ sender: Any) {
		self.dismissViewController()
	}

	// MARK: Save book details into coredata
	@objc func saveBookDetails(_ sender: Any) {
		guard let bookTitle = bookTitle.text, let author = author.text, let isbn = isbn.text, bookTitle.length > 0, author.length > 0, isbn.length > 0 else {
			let okAlertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
			self.showAlert(title: "Alert", message: "ISBN, title & author are mandatory!", actions: [okAlertAction])
			print("Unable to unwrap the book details!")
			return
		}
		if flowState == .create {
			book = ManageBooks.shared.createManagedObjectBook(errorHandler: { (error) in
							showToast(message: error.errorType.rawValue)
							print(error)
						})
			book?.title = bookTitle
			book?.authorName = author
			book?.genre = genre.text
			book?.noOfPages = Int16(noOfPages.text ?? "0") ?? 0
			book?.synopsis = synopsis.text
			book?.isbn = isbn
		}
		
		guard let book = book else {
			showToast(message: "Failed to Save!")
			return
		}
		
		ManageBooks.shared.insertNewBook(book: book, flowState: flowState,sender: self) { (error) in
			showToast(message: error.errorType.rawValue)
			print(error)
		}
//		guard isCreated else {
//			return
//		}
		addBookToListDelegate?.performAction(flowState: .create, book: book)
		self.dismissViewController()
	}
}
