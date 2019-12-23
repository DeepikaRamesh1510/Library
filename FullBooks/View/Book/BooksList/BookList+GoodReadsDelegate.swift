//
//  BookList+GoodReadsDelegate.swift
//  FullBooks
//
//  Created by user on 21/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit

extension BooksListViewController: GoodReadsLibraryDelegate {
	
	func reloadContent(books: [GoodReadsBook]) {
		self.tableView.tableFooterView = UIView()
		self.goodReadsBooks = books
		self.tableView.reloadData()
	}
	
}
