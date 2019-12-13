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
	var books = [Book]()
	var xmlParser: XMLParser?
	var elementName = String()
	var title = ""
	var id = ""
	var authorName = ""
	var synopsis = ""
	var imageURL = ""
	var imageData: UIImage?
	
	//MARK: Serializing the XML Data
	
	func parseTheXMLData(xmlData: Data) -> [Book] {
		xmlParser = XMLParser(data: xmlData)
		xmlParser?.delegate = self
		xmlParser?.parse()
		return books
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
		}
		self.elementName = elementName
	}
	
	func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
		if elementName == "best_book" {
			guard let book = ManageBooks.shared.createManagedObjectBook(errorHandler: { (error) in
				print("error occured while creating instances for the book!")
			}) else {
				print("Failed to creat the book managed object!")
				return
			}
			book.bookId = self.id;
			book.authorName = self.authorName;
			book.title = self.title;
			print(book)
			self.books.append(book);
		}
	}
	
	func parserDidEndDocument(_ parser: XMLParser) {
		print("Here we should have func to ")
	}
	
}

