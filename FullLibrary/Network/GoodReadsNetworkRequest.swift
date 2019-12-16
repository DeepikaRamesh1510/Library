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
	
	func fetchBooks(bySearch searchString: String, completionHandler: @escaping (Data?,Error?) -> Void) {
        parameters["q"] = searchString
		networkManager.getRequest(url: goodReadsConstants.getEndPoint(path: .searchBooksWithNameAuthorISBN), encoding: nil, parameters: parameters, headers: nil, completionHandler: completionHandler)
	}
	
	func fetchBookImage(imageURL: String) {
		
	}
//	return results
}
