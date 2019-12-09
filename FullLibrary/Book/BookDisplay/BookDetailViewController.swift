//
//  BookDetailViewController.swift
//  FullLibrary
//
//  Created by user on 05/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    @IBOutlet var bookTitle: UILabel!
    @IBOutlet var author: UILabel!
    @IBOutlet var sysnopsis: UITextView!
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performNavigationBarViewChanges()
    }
    
    func performNavigationBarViewChanges() {
		let updateImage = UIImage(named: ImageAssets.pencil.rawValue)
        let updateButton = UIBarButtonItem(image: updateImage, style: .plain, target: self, action: #selector(presentUpdateViewController(_:)))
        navigationController?.changeNavigationBarContent(target: self,title: "Book", rightBarButton: updateButton)
    }
    
    @objc func presentUpdateViewController(_ sender: UIBarButtonItem) {
        guard let bookViewController = storyboard?.instantiateViewController(withIdentifier: ViewController.book.rawValue) as? BookViewController else {
            print("Failed to instatiate book view Controller")
            return
        }
//        bookViewController.navigationBarTitle = "Update Book"
//		if let book = book {
			bookViewController.book = book
//		}
        bookViewController.flowState = .update
        present(bookViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bookTitle.text = book?.title
        author.text = book?.authorName
        sysnopsis.text = book?.synopsis
    }
    
}
