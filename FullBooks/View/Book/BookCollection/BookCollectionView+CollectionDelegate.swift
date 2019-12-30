
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
		myLibraryBooks.count == 0 ?
			collectionView.setEmptyMessage("No Books added to library!") : collectionView.setBackgroundView(view: nil)
		
		return myLibraryBooks.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as! BookCollectionViewCell
		bookCell.fullBooksViewModel = fullBooksViewModel
		bookCell.updateCellComponent(newBook: myLibraryBooks[indexPath.row])
		return bookCell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		showBookDetailPage( myLibraryBook: myLibraryBooks[indexPath.item])
		collectionView.deselectItem(at: indexPath, animated: true)
	}
	
	func showBookDetailPage(myLibraryBook: Book?) {
		guard let bookDetailViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.bookDetailViewController.rawValue) as? BookDetailViewController else {
			return
		}
		
			bookDetailViewController.myLibraryBook = myLibraryBook
		
		bookDetailViewController.libraryState = .myLibrary
		navigationController?.pushViewController(bookDetailViewController, animated: true)
	}
	
}

extension BookCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 210)
    }
}
