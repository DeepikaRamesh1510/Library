//
//  BookViewController.swift
//  FullLibrary
//
//  Created by user on 09/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

	@IBOutlet var bookViewBackButton: UIButton!
	@IBOutlet var bookViewTitle: UILabel!
	@IBOutlet var staticTableContainer: UIView!
	var bookStaticTableController: BookStaticTableViewController?
	var addBookToListDelegate: BookProtocol?
	var bookUpdationDelegate: BookUpdationProtocol?
	var flowState: FlowState = .create
	override func viewDidLoad() {
        super.viewDidLoad()

    }
    
	
	@IBAction func closeTheViewController(_ sender: Any) {
		guard checkForAnyChanges() else {
			self.dismissBookView()
			return
		}
		let confirmAction = UIAlertAction(title: "Yes", style: .destructive) { (action) in
			self.dismissBookView()
		}
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		showAlert(title: "Alert", message: "Do you want to dicard the changes?", actions: [cancelAction,confirmAction])
	}
	
	func dismissBookView() {
		let appDelegate = UIApplication.shared.delegate as? AppDelegate
		self.dismissViewController()
		appDelegate?.floatingButtonController?.isVisible = true
	}
	
	func checkForAnyChanges() -> Bool {
		return ManageBooks.shared.checkForChanges()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == ContainerSegue.bookStaticTable.rawValue {
			guard let bookStaticTableViewController = segue.destination as? BookStaticTableViewController else {
				print("Unable to embbed static table!")
				self.showToast(message: "Failed")
				return
			}
			if flowState == .create {
				bookStaticTableViewController.addBookToListDelegate = self.addBookToListDelegate
				bookViewTitle?.text = "New Book"
			} else {
				bookStaticTableViewController.bookUpdationDelegate = self.bookUpdationDelegate
				bookViewTitle?.text = "New Book"
			}
		}
	}
	
}
