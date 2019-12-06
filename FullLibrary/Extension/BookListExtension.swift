//
//  BookListExtension.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit


extension BooksListViewController: UITableViewDelegate, UITableViewDataSource, AddBookToListDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTheBooks()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        navigationItem.title = "Books"
        let plusImage = UIImage(named: "plusIcon")
        let addNewBookButton = UIBarButtonItem(image: plusImage, style: .plain, target: self, action: #selector(presentBookCreationViewController(_:)))
        addNewBookButton.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = addNewBookButton
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bookCell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookListCellTableViewCell
        bookCell.title.text = books[indexPath.item].title
        bookCell.author.text = books[indexPath.item].authorName
        bookCell.synopsis.text = books[indexPath.item].synopsis
        return bookCell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var isDeleted: Bool = true
            guard let bookTitle = books[indexPath.item].title else {
                showToast(message: "Deletion Failed!")
                return
            }
            ManageBooks.shared.deleteBook(title: bookTitle) { (error) in
                showToast(message: error.errorType.rawValue)
                isDeleted = false
                return
            }
            guard isDeleted else {
                return
            }
            self.books.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print(indexPath.item)
            
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "BookCreationSegue" {
//            guard let bookCreationViewController = segue.destination as? BookCreationViewController else {
//                print("Unable to cast the viewcontroller to the book creation controller!")
//                return
//            }
//            bookCreationViewController.addBookToListDelegate = self
//        }
//    }
    
    func addBookToList(newBook : Book) {
        books.append(newBook)
        tableView.reloadData()
    }
}
