//
//  GoodReadsNetworkRequest.swift
//  FullLibrary
//
//  Created by user on 12/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

class GoodReadsNetworkRequest {
	
	static let shared = GoodReadsNetworkRequest()
	let networkManager = NetworkManager()
	let goodReadsConstants = GoodReadsConstants()
	var parameters = [String: Any]()
	var headers = [String: String]()
	
	init() {
		clearParameter()
	}
	
	func clearParameter() {
		parameters = ["key" : goodReadsConstants.key]
	}
	
	func fetchBooks(bySearch searchString: String, pageNumber: Int, completionHandler: @escaping (Data?,Error?) -> Void) {
        parameters["q"] = searchString
		parameters["page"] = pageNumber
		networkManager.getRequest(url: goodReadsConstants.getEndPoint(path: .searchBooksWithNameAuthorISBN), encoding: nil, parameters: parameters, headers: nil, completionHandler: completionHandler)
		clearParameter()
	}
	
	func fetchSynopsis(bookId: String, completionHandler: @escaping (Data?, Error?) -> Void) {
		networkManager.getRequest(url: goodReadsConstants.getEndPoint(path: .getBookDescriptionWithBookId) + "\(bookId).xml", encoding: nil, parameters: self.parameters, headers: nil, completionHandler: completionHandler)
		clearParameter()
	}
	
	func fetchBookImage(imageURL: String, completionHandler: @escaping (Data?,Error?) -> Void ) {
//		networkManager.downloadFile(fileURL: imageURL, completionHandler: completionHandler)
		networkManager.getRequest(url: imageURL, encoding: nil, parameters: nil, headers: nil, completionHandler: completionHandler)
	}
}
