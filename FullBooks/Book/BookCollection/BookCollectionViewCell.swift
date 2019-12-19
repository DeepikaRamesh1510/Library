//
//  BookCollectionViewCell.swift
//  FullBooks
//
//  Created by user on 19/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    
	@IBOutlet var favorite: UIImageView!
	@IBOutlet var rating: UILabel!
	@IBOutlet var author: UILabel!
	@IBOutlet var title: UILabel!
	@IBOutlet var bookImage: UIImageView!
	
	func setValueForCellProperties(book: Book) {
		rating.text = String(book.rating)
		author.text = book.authorName
		title.text = book.title
		if let imageData = book.image {
			bookImage.image = UIImage(data: imageData)
		} else {
			bookImage.image = UIImage(named: "BookList")
		}
		
	}
}
