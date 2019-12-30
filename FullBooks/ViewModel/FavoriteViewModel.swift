//
//  LikeControlViewModel.swift
//  FullBooks
//
//  Created by user on 24/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

protocol FavoriteBookDelegate: class {
	func updateFavoriteStatus()
}
class FavoriteViewModel {
	weak var delegate: FavoriteBookDelegate?
	let fullBooksViewModel: FullBooksViewModel
	init(fullBooksViewModel: FullBooksViewModel) {
		self.fullBooksViewModel = fullBooksViewModel
	}
	
	func updateFavoriteStatus(book: Book?) {
//		book?.isFavorite = !
		guard let book = book else {
			print("Received nil value for the book!")
			return
		}
		book.isFavorite = !book.isFavorite
		fullBooksViewModel.updateBookContent()
		delegate?.updateFavoriteStatus()
	}

}
