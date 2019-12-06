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
        navigationItem.title = "Book"
        let updateImage = UIImage(named: "pencilIcon")
        let updateButton = UIBarButtonItem(image: updateImage, style: .plain, target: self, action: #selector(presentUpdateViewController(_:)))
    }
    
    @objc func presentUpdateViewController(_ sender: UIBarButtonItem){
        guard let bookUpdateViewController = storyboard?.instantiateViewController(withIdentifier: "BookCreationOrUpdateViewController") as? BookCreationOrUpdateViewController else {
            print("Failed to instatiate book creation view Controller")
            return
        }
        present(bookUpdateViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bookTitle.text = book?.title
        author.text = book?.authorName
        sysnopsis.text = book?.synopsis
    }
    
}
