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
	var books = [GoodReadsBook]()
	var xmlParser: XMLParser?
	var elementName = String()
	var title = ""
	var id = ""
	var authorName = ""
	var synopsis = ""
	var imageURL = ""
	var rating = ""
	var imageData: UIImage?
	
	//MARK: Serializing the XML Data
	
	func initializeParser(xmlData: Data) {
		xmlParser = XMLParser(data: xmlData)
		xmlParser?.delegate = self
		xmlParser?.parse()
	}
	
	func parseTheXMLData(xmlData: Data) -> [GoodReadsBook] {
		initializeParser(xmlData: xmlData)
//		xmlParser = XMLParser(data: xmlData)
//		xmlParser?.delegate = self
//		xmlParser?.parse()
		return books
	}
	
	func parseSynopsis(xmlData: Data) -> String {
		initializeParser(xmlData: xmlData)
		return synopsis
	}
	
	func parserDidStartDocument(_ parser: XMLParser) {
		print("Startes to parse the doc!")
	}

	func parser(_ parser: XMLParser, foundCharacters string: String) {
		let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
		if (!data.isEmpty) {
			if self.elementName == "title" {
				self.title += data
			} else if self.elementName == "name" {
				self.authorName += data
			} else if self.elementName == "description" {
				self.synopsis += data
			} else if self.elementName == "id" {
				self.id += data
			} else if self.elementName == "small_image_url" {
				self.imageURL += data
			} else if self.elementName == "average_rating" {
				self.imageURL += data
			}
		}
	}
	
	func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
		if elementName == "best_book" {
			self.title = ""
			self.authorName = ""
			self.synopsis = ""
			self.id = ""
			self.imageURL = ""
			self.rating = ""
		} else if elementName == "description" {
			self.synopsis = ""
		}
		self.elementName = elementName
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "best_book" {
			let tempBook = GoodReadsBook()
			tempBook.bookId = self.id;
			tempBook.authorName = self.authorName;
			tempBook.title = self.title;
			tempBook.rating = Float(self.rating) ?? 0.0
			tempBook.imageUrl = self.imageURL
			print(tempBook)
			self.books.append(tempBook);
		}
	}
	
//	func parserDidEndDocument(_ parser: XMLParser) {
//		print("Here we should have func to ")
//	}
	
	// functtion to fetch the image for the books
	
	
}

