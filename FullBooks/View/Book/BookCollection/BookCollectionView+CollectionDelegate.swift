
//
//  BookCollectionView+CollectionDelegate.swift
//  FullBooks
//
//  Created by user on 20/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension BookCollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if myLibraryBooks.count == 0 {
			collectionView.setEmptyMessage("No Books added to library!")
		}
		return myLibraryBooks.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as! BookCollectionViewCell
		bookCell.rating?.text = String(myLibraryBooks[indexPath.row].rating)
		bookCell.author?.text = myLibraryBooks[indexPath.row].authorName
		bookCell.title?.text = myLibraryBooks[indexPath.row].title
		if let imageData = myLibraryBooks[indexPath.row].image {
			bookCell.bookImage?.image = UIImage(data: imageData)
		} else {
			bookCell.bookImage?.image = UIImage(named: "BookList")
		}
		bookCell.layer.borderWidth = 1
		bookCell.layer.borderColor = UIColor.systemGray.cgColor
		bookCell.layer.cornerRadius = 5
		return bookCell
	}
	
}

extension BookCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 210)
    }
}
