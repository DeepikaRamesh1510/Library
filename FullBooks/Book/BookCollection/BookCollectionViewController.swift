//
//  BookCollectionCollectionViewController.swift
//  FullBooks
//
//  Created by user on 19/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BookCollectionViewCell"

class BookCollectionViewController: UICollectionViewController {
var booksManager: BooksManager?
	var myLibraryBooks = [Book]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		getBookManagerInstance()
		getTheBooks()
        // Do any additional setup after loading the view.
    }
	
	func getBookManagerInstance() {
		guard let rootNavigationController = self.navigationController as? RootNavigationController else {
			print("Unable to fetch the root navigation Controller!")
			return
		}
		booksManager = BooksManager(dataManager: rootNavigationController.dataManager)
	}
	
	func getTheBooks(){
		guard let result = booksManager?.fetchBooks() else {
			print("Unable to fetch data!")
			return
		}
		self.myLibraryBooks = result
		collectionView.reloadData()
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
		return myLibraryBooks.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let bookCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BookCollectionViewCell
//		cell.setValueForCellProperties(book: myLibraryBooks[indexPath.item])
        // Configure the cell
    
        return bookCell
    }

    // MARK: UICollectionViewDelegate

    /*
     Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
