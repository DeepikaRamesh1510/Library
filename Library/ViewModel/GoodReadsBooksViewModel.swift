//
//  GoodReadsNetworkRequest.swift
//  FullLibrary
//
//  Created by user on 12/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit

protocol GoodReadsLibraryDelegate: class {
	var goodReadsBooks: [GoodReadsBook] { get set }
	var currentPage: Int { get set }
	func reloadContent(books: [GoodReadsBook])
	var isLoadingList: Bool { get set }
}
class GoodReadsBooksViewModel {
	weak var delegate: GoodReadsLibraryDelegate?
	var coreDataManager: CoreDataManager!
	let networkManager: NetworkManager!
	let goodReadsConstants = GoodReadsConstants()
	var parameters = [String: Any]()
	var headers = [String: String]()
	
	init(coreDataManager: CoreDataManager, networkManager: NetworkManager) {
		self.coreDataManager = coreDataManager
		self.networkManager = networkManager
	}
	
	func setKeyToApi() {
		parameters = ["key" : goodReadsConstants.key]
	}
	
	func fetchBooks(bySearch searchString: String, pageNumber: Int) {
		guard let delegate = delegate else {
			print("delegate is nil!")
			return
		}
		setKeyToApi()
        parameters["q"] = searchString
		parameters["page"] = pageNumber
		networkManager.getRequest(url: goodReadsConstants.getEndPoint(path: .searchBooksWithNameAuthorISBN), encoding: nil, parameters: parameters, headers: nil) { (data,error) in
			delegate.isLoadingList = false
			if let error = error {
				print(error.localizedDescription)
				return
			}
			guard let data = data else {
				print("Data not received!")
				return
			}
			let xmlResponseParser = XMLResponseParser()
			delegate.goodReadsBooks += xmlResponseParser.parseTheXMLData(xmlData: data)
			delegate.currentPage += 1
			delegate.reloadContent(books: delegate.goodReadsBooks)
		}
		
	}
	
	func fetchSynopsis(bookId: String, completionHandler: @escaping (Data?, Error?) -> Void) {
		setKeyToApi()
		networkManager.getRequest(url: goodReadsConstants.getEndPoint(path: .getBookDescriptionWithBookId) + "\(bookId).xml", encoding: nil, parameters: self.parameters, headers: nil, completionHandler: completionHandler)
	}
	
	func fetchBookImage(imageURL: String, completionHandler: @escaping (Data?,Error?) -> Void ) {
		networkManager.getRequest(url: imageURL, encoding: nil, parameters: nil, headers: nil, completionHandler: completionHandler)
	}
}
