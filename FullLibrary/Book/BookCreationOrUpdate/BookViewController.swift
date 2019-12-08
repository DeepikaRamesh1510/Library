//
//  BookViewController.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookCreationOrUpdateViewController: UIViewController {

    @IBOutlet var navigationBar: UINavigationBar!
    @IBOutlet var synopsis: UITextField!
    @IBOutlet var noOfPages: UITextField!
    @IBOutlet var genre: UITextField!
    @IBOutlet var author: UITextField!
    @IBOutlet var bookTitle: UITextField!
    weak var addBookToListDelegate: AddBookToListDelegate?
    var book: Book?
    var navigationBarTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBar.topItem?.title = navigationBarTitle
        guard let bookToBeUpdated = book else {
            return
        }
        bookTitle.text = bookToBeUpdated.title
        author.text = bookToBeUpdated.authorName
        noOfPages.text = String(bookToBeUpdated.noOfPages)
        synopsis.text = bookToBeUpdated.synopsis
        genre.text = bookToBeUpdated.genre
    }
    
    func dismissModal(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModal(_ sender: Any) {
        dismissModal()
    }
    @IBAction func cancelInsertionOfData(_ sender: Any) {
        dismissModal()
    }
    @IBAction func insertNewBookIntoLibrary(_ sender: Any) {
        var isCreated: Bool = true
        guard let book = ManageBooks.shared.createManagedObjectBook(errorHandler: { (error) in
            showToast(message: error.errorType.rawValue)
            print(error)
        }) else {
            showToast(message: "Creation Failed")
            return
        }
        guard let bookTitle = bookTitle.text, let author = author.text else {
            print("Unable to unwrap the book details!")
            return
        }
        book.title = bookTitle
        book.authorName = author
        book.genre = genre.text
        book.noOfPages = Int16(noOfPages.text ?? "0") ?? 0
        book.synopsis = synopsis.text
        ManageBooks.shared.insertNewBook(book: book) { (error) in
            showToast(message: error.errorType.rawValue)
            isCreated = false
            print(error)
        }
        guard isCreated else {
            return
        }
        addBookToListDelegate?.addBookToList(newBook: book)
        dismissModal()
    }
    

}
