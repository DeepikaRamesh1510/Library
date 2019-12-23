//
//  BookListExtension.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit

extension BooksListViewController: FullLibraryDelegate {
	
	func reloadContent(book: [Book]) {
		self.myLibraryBooks = book
		self.tableView.reloadData()
	}

}

