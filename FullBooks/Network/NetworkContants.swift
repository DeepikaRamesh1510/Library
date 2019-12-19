//
//  NetworkContants.swift
//  FullLibrary
//
//  Created by user on 10/12/19.
//  Copyright © 2019 user. All rights reserved.
//

// to use the add, modify and delete a review we need to register our application with the good reads

import UIKit

typealias QueryParameter = [ String: String]

enum HTTPResponseError:String , Error {
	case redirection
	case clientError
	case serverError
	case undefined
}

class GoodReadsBook {
	var bookId = String()
	var synopsis = String()
	var title = String()
	var authorName = String()
	var imageUrl = String()
	var image = Data()
	var rating = Float()
	var noOfCopies = Int16()
}

struct GoodReadsConstants {
	let goodReadsBaseUrl = "https://www.goodreads.com/"
	let key = "OCXeO7bbsFxyuVXamEX6w"
	let secret = "L5VSaX9uIQLRRZyyQyYPuVdZWg6ujHVQoM7ke8846s"
	enum Path: String {
		case booksOfAuthor = "author/list.xml"  //xml response
		case getAuthorByName = "api/author_url" // ''
		case getBookIDByISBN = "book/isbn_to_id " //xml response
		case getBookDescriptionWithBookId = "book/show/" // '/show/bookID.format' -> this should be followed by the book id and the format in which we require the results to be in
		case getBookReviewWithISBN = "book/isbn/" //  'isbn/ISBN?format=FORMAT' -> this api fetches the review for a book based on the isbn given, we can choose the format in which we require the results to be
		case searchBooksWithNameAuthorISBN = "search/index.xml" // specify the query string in the parameter with the key 'q'
		case getBookDescriptionAlongWithReview = ""
	}
	func getEndPoint(path: Path) -> String {
		return goodReadsBaseUrl + path.rawValue
	}
}

