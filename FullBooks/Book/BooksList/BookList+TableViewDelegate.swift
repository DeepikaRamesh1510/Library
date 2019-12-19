//
//  BookList+TableViewHelper.swift
//  FullLibrary
//
//  Created by user on 16/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension BooksListViewController: UITableViewDelegate , UITableViewDataSource {
	
	//MARK: helper methods for cell and table modification according to library state and the book count
	func modifyBookCellByState(title: String, author: String, imageData: Data?) -> BookTableViewCell {
		let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookTableViewCell
		bookCell.title.text = title
		bookCell.author.text = author
		bookCell.parentViewController = self
		bookCell.addBookButton.isEnabled = libraryState == .goodReads ? true : false
		bookCell.addBookButton.isHidden = libraryState == .goodReads ? false : true
		if let imageData = imageData {
			bookCell.bookImage.image = UIImage(data: imageData)
		}
		else {
			bookCell.bookImage.image =  UIImage(named: "bookList")
		}
		
		return bookCell
	}
	
	func checkBookCount(rowCount: Int) {
		if rowCount == 0 {
			var message = String()
			if self.searchText.length == 0 {
				message = libraryState == .myLibrary ? "No Books added to the library" : "Search for books in Good Reads library"
			} else {
				message = "The searched book is not available in the library!"
			}
			self.tableView.setEmptyMessage(message)
		} else {
			self.tableView.restore()
		}
	}
	
	func deleteBookFromMyLibrary(bookId: String?, indexPath: IndexPath) {
		var isDeleted: Bool = true
		guard let bookId = bookId else {
			showToast(message: "Deletion Failed!")
			return
		}
		booksManager?.deleteBook(bookId: bookId) { (error) in
			guard let error = error else {
				return
			}
			self.showToast(message: error.errorType.rawValue)
			isDeleted = false
			return
		}
		guard isDeleted else {
			return
		}
		self.myLibraryBooks.remove(at: indexPath.row)
		tableView.deleteRows(at: [indexPath], with: .fade)
		print(indexPath.item)
	}
	
	//MARK: table view delegate methods
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let rowCount: Int = libraryState == .myLibrary ? myLibraryBooks.count : goodReadsBooks.count
		checkBookCount(rowCount: rowCount)
		return rowCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard libraryState == .goodReads  else {
			return modifyBookCellByState(title: myLibraryBooks[indexPath.item].title ?? "", author: myLibraryBooks[indexPath.item].authorName ?? "", imageData: myLibraryBooks[indexPath.item].image)
		}
		let goodReadsBookCell = modifyBookCellByState(title: goodReadsBooks[indexPath.item].title, author: goodReadsBooks[indexPath.item].authorName, imageData: nil)
		GoodReadsNetworkRequest.shared.fetchBookImage(imageURL: goodReadsBooks[indexPath.item].imageUrl){ (data,error) in
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else {
				print("Data not received!")
				return
			}
			self.goodReadsBooks[indexPath.item].image = data
			goodReadsBookCell.bookImage.image = UIImage(data: data)
		}
		return goodReadsBookCell
	}
	
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if libraryState == .myLibrary && editingStyle == .delete{
			deleteBookFromMyLibrary(bookId: myLibraryBooks[indexPath.item].bookId, indexPath: indexPath)
		}
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		libraryState == .goodReads ? showBookDetailPage(goodReadsBook: goodReadsBooks[indexPath.item], myLibraryBook: nil) : showBookDetailPage(goodReadsBook: nil, myLibraryBook: myLibraryBooks[indexPath.item])
		
		tableView.deselectRow(at: indexPath, animated: true)
	}
	
	func showBookDetailPage(goodReadsBook: GoodReadsBook?,myLibraryBook: Book?) {
		guard let bookDetailViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.bookDetailViewController.rawValue) as? BookDetailViewController else {
			return
		}
		if libraryState == .myLibrary {
			bookDetailViewController.myLibraryBook = myLibraryBook
		} else {
			bookDetailViewController.goodReadsBook = goodReadsBook
		}
		bookDetailViewController.libraryState = libraryState
		navigationController?.pushViewController(bookDetailViewController, animated: true)
	}
	
	//	scroll delegate to fetch more books
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if libraryState == .goodReads {
			if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoadingList){
				self.isLoadingList = true
				let spinner = UIActivityIndicatorView(style: .gray)
				spinner.startAnimating()
				spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: 50)
				
				self.tableView.tableFooterView = spinner
				if libraryState == .goodReads {
					self.fetchBooksInGoodReadsLibrary(bySearch: self.searchText)
				}
			}
		}
		
	}
	
}
