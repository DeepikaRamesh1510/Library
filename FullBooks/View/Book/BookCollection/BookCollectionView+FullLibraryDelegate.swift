//
//  BookCollectionView+FullLibraryDelegate.swift
//  FullBooks
//
//  Created by user on 21/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

extension BookCollectionViewController: FullLibraryDelegate {
	func reloadContent(book: [Book]) {
		self.myLibraryBooks = book
		self.collectionView.reloadData()
	}
}
