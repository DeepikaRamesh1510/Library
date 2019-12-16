//
//  BookList+TableViewHelper.swift
//  FullLibrary
//
//  Created by user on 16/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension BooksListViewController {
	
	//MARK: table view delegate methods
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

			let rowCount: Int = libraryState == .myLibrary ? myLibraryBooks.count : goodReadsBooks.count
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
			return rowCount
		}
		
		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookTableViewCell
			if libraryState == .myLibrary {
				bookCell.title.text = myLibraryBooks[indexPath.item].title
				bookCell.author.text = myLibraryBooks[indexPath.item].authorName
				bookCell.parentViewController = self
				bookCell.addBookButton.isEnabled = false
				bookCell.addBookButton.isHidden = true
				return bookCell
			} else {
				bookCell.title.text = goodReadsBooks[indexPath.item].title
				bookCell.author.text = goodReadsBooks[indexPath.item].authorName
				bookCell.parentViewController = self
				bookCell.addBookButton.isEnabled = true
				bookCell.addBookButton.isHidden = false
				return bookCell
			}
		}
		
		func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
			if libraryState == .myLibrary {
				if editingStyle == .delete {
					var isDeleted: Bool = true
					guard let bookISBN = myLibraryBooks[indexPath.item].isbn else {
						showToast(message: "Deletion Failed!")
						return
					}
					ManageBooks.shared.deleteBook(isbn: bookISBN) { (error) in
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
			}
			
		}
		
		func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
			if libraryState == .myLibrary {
				guard let bookDetailViewController = storyboard?.instantiateViewController(withIdentifier: "BookDetailViewController") as? BookDetailViewController else {
					print("Failed to open instantiate book detail view controller")
					return
				}
				bookDetailViewController.book = myLibraryBooks[indexPath.item]
	//			bookDetailViewController.bookUpdationDelegate = self
				navigationController?.pushViewController(bookDetailViewController, animated: true)
			}
			
			tableView.deselectRow(at: indexPath, animated: true)
		}
		
}
