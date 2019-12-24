//
//  BookCollectionCollectionViewController.swift
//  FullBooks
//
//  Created by user on 19/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

private let reuseIdentifier = "BookCollectionViewCell"

class BookCollectionViewController: UIViewController {
	var fullBooksViewModel: FullBooksViewModel!
	var myLibraryBooks = [Book]()
	@IBOutlet weak var collectionView: UICollectionView!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.collectionView.delegate = self
		self.collectionView.dataSource = self
		initializeFullLibraryViewModel()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		getTheBooks()
		setNavigationBarTitle()
	}
	
	func setNavigationBarTitle() {
	self.navigationController?.changeNavigationBarContent(target: self, title: "Full Library", rightBarButton: nil)
	}
	
	func initializeFullLibraryViewModel() {
		let rootNavigationController = self.navigationController as! RootNavigationController
		fullBooksViewModel = FullBooksViewModel(coreDataManager: rootNavigationController.coreDataManager)
		fullBooksViewModel.delegate = self
	}
	
	func getTheBooks(){
		fullBooksViewModel.fetchBooks()
	}

}
