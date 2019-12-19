//
//  BookViewController.swift
//  FullLibrary
//
//  Created by user on 09/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {
	
	@IBOutlet weak var bookViewBackButton: UIButton!
	@IBOutlet weak var bookViewTitle: UILabel!
	@IBOutlet weak var staticTableContainer: UIView!
	@IBOutlet weak var saveButton: UIButton!
	var bookStaticTableController: BookStaticTableViewController?
	var addBookToListDelegate: BookProtocol?
	var bookUpdationDelegate: BookUpdationProtocol?
	var flowState: FlowState = .create
	override func viewDidLoad() {
		super.viewDidLoad()
		renderForFlowState()
	}
	
	func renderForFlowState() {
//		if flowState == .create {
//			self.saveButton.titleLabel?.text = "Add Books To Library"
//		} else {
//			self.saveButton.titleLabel?.text = "Update Book"
//		}
	}
	
	@IBAction func closeTheViewController(_ sender: Any) {
//		guard checkForAnyChanges() else {
//			self.dismissBookView()
//			return
//		}
//		let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
//			self.dismissBookView()
//		}
//		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//		showAlert(title: "Alert", message: "Do you want to dicard the changes?", actions: [cancelAction,confirmAction])
	}
	
	func dismissBookView() {
		self.dismissViewController()
	}
	
//	func checkForAnyChanges() -> Bool {
//		return ManageBooks.shared.checkForChanges()
//	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == ContainerSegue.bookStaticTable.rawValue {
			guard let bookStaticTableViewController = segue.destination as? BookStaticTableViewController else {
				print("Unable to embbed static table!")
				self.showToast(message: "Failed")
				return
			}
			if flowState == .create {
				bookStaticTableViewController.addBookToListDelegate = self.addBookToListDelegate
				bookViewTitle?.text = "Add Book"
			} else {
				bookStaticTableViewController.bookUpdationDelegate = self.bookUpdationDelegate
				bookViewTitle?.text = "Update Book"
			}
		}
	}
	
}
