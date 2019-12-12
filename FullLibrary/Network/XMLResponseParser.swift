//
//  GoodReads.swift
//  FullLibrary
//
//  Created by user on 11/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit




class XMLResponseParser: NSObject, XMLParserDelegate {
	var goodReadBooks = [GoodReadsBook]()
	var goodReadBook = GoodReadsBook()
	var foundCharacters = ""
	var xmlParser: XMLParser?
	
	//MARK: Serializing the XML Data
	
	func parseTheXMLData(xmlData: Data) -> [GoodReadsBook] {
		xmlParser = XMLParser(data: xmlData)
		xmlParser?.delegate = self
		xmlParser?.parse()
		return goodReadBooks
	}
	
	func parserDidStartDocument(_ parser: XMLParser) {
		print("Startes to parse the doc!")
	}
	
	
	func parser(_ parser: XMLParser, foundCharacters string: String) {
		self.foundCharacters += string;
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		
		if elementName == "id" {
					self.goodReadBook.bookId = self.foundCharacters
					
				}
				if elementName == "name" {
					self.goodReadBook.name = self.foundCharacters
					
				}
				if elementName == "title" {
					self.goodReadBook.title = self.foundCharacters
					
				}
				if elementName == "description" {
				}
				
				if elementName == "work" {
					let book = GoodReadsBook();
					book.bookId = self.goodReadBook.bookId;
					book.name = self.goodReadBook.name;
					book.title = self.goodReadBook.title;
		//			book.imageUrl = self.goodReadBook.imageUrl
					self.goodReadBooks.append(book);
				}
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		print(goodReadBooks)
	}
	
}

