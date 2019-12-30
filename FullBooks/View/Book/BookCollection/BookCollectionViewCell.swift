//
//  BookCollectionViewCell.swift
//  FullBooks
//
//  Created by user on 19/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell, FavoriteBookDelegate {
	
	@IBOutlet var rating: UILabel!
	@IBOutlet var author: UILabel!
	@IBOutlet var title: UILabel!
	@IBOutlet var bookImage: UIImageView!
	@IBOutlet var favorite: UIButton!
	weak var book: Book?
	var fullBooksViewModel: FullBooksViewModel!
	var favoriteViewModel: FavoriteViewModel!
	func updateCellComponent(newBook: Book) {
		self.rating.text = String(newBook.rating)
		self.author.text = newBook.authorName
		self.title.text = newBook.title
		if let imageData = newBook.image {
			self.bookImage.image = UIImage(data: imageData)
		}
		
		book = newBook
		self.layer.borderWidth = 1
		self.layer.borderColor = UIColor.systemGray.cgColor
		self.layer.cornerRadius = 5
		updateFavoriteStatus()
		favoriteViewModel = FavoriteViewModel(fullBooksViewModel: fullBooksViewModel)
		favoriteViewModel.delegate = self
	}
	
	func updateFavoriteStatus() {
		guard let book = book else {
			return
		}
		book.isFavorite ? setFavoriteButton(tintColor: .systemRed) : setFavoriteButton(tintColor: .systemGray)
	}
	
	func setFavoriteButton(tintColor color: UIColor) {
		self.favorite.tintColor = color
	}
	@IBAction func changeFavoriteStatus(_ sender: Any) {
		favoriteViewModel.updateFavoriteStatus(book: book)
	}
}
