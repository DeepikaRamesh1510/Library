//
//  NetworkManager.swift
//  FullLibrary
//
//  Created by user on 10/12/19.
//  Copyright © 2019 user. All rights reserved.
//

//import Foundation
import Alamofire


class NetworkManager {
//	let shared = NetworkManager()
//	init() { }
	
	//MARK: Generic network request
	
	let validationClosure = { (resquest: URLRequest?, response: HTTPURLResponse, data: Data?) -> Request.ValidationResult in
		let statusCode = response.statusCode
		switch statusCode {
			case 200..<300:
				return .success
			case 400..<500:
				return .failure(HTTPResponseError.clientError)
			case 500..<600:
				return .failure(HTTPResponseError.serverError)
			default:
				return .failure(HTTPResponseError.undefined)
		}
	}
	
	func makeRequest(url: URLConvertible, method: HTTPMethod,encoding: ParameterEncoding?,parameters: Parameters?, headers: HTTPHeaders?, completionHandler:@escaping (Data) -> Void ) {
		let parameterEncoding = encoding ?? URLEncoding.default
		Alamofire.request(url, method: method, parameters: parameters, encoding: parameterEncoding, headers: headers).validate(validationClosure).response { response in
			print(response)
			guard let data = response.data else {
				print("Data not received!")
				return
			}
			completionHandler(data)
		}
	}
	
	//MARK: Get requests
	
	//get request with all the encoding, parameters and headers
	func getRequest(url: URLConvertible, encoding: ParameterEncoding?,parameters: Parameters?, headers: HTTPHeaders?, completionHandler: @escaping (Data) -> Void) {
		makeRequest(url: url, method: .get, encoding: encoding, parameters: parameters, headers: headers, completionHandler: completionHandler)
	}
	
	//get request without encoding
	func getRequest(url: URLConvertible,parameters: Parameters?, headers: HTTPHeaders?, completionHandler: @escaping (Data) -> Void) {
		makeRequest(url: url, method: .get, encoding: nil, parameters: parameters, headers: headers, completionHandler: completionHandler)
	}
	
	//get request without parameters but it has headers
	func getRequest(url: URLConvertible, headers: HTTPHeaders?, completionHandler: @escaping (Data) -> Void) {
		makeRequest(url: url, method: .get, encoding: nil, parameters: nil, headers: headers, completionHandler: completionHandler)
	}
	
	//get request with just only parameters
	func getRequest(url: URLConvertible,parameters: Parameters?, completionHandler: @escaping (Data) -> Void) {
		makeRequest(url: url, method: .get, encoding: nil, parameters: parameters, headers: nil, completionHandler: completionHandler)
	}
	
	//MARK: Post Request
	//Post request with all the encoding, parameters and headers
	func postRequest(url: URLConvertible, encoding: ParameterEncoding?,parameters: Parameters?, headers: HTTPHeaders?, completionHandler: @escaping (Data) -> Void) {
		makeRequest(url: url, method: .post, encoding: encoding, parameters: parameters, headers: headers, completionHandler: completionHandler)
	}
	
	//Post request without encoding
	func postRequest(url: URLConvertible,parameters: Parameters?, headers: HTTPHeaders?, completionHandler: @escaping (Data) -> Void) {
		makeRequest(url: url, method: .post, encoding: nil, parameters: parameters, headers: headers, completionHandler: completionHandler)
	}
	
	//Post request without parameters but it has headers
	func postRequest(url: URLConvertible, headers: HTTPHeaders?, completionHandler: @escaping (Data) -> Void) {
		makeRequest(url: url, method: .post, encoding: nil, parameters: nil, headers: headers, completionHandler: completionHandler)
	}
	
	//Post request with just only parameters
	func postRequest(url: URLConvertible,parameters: Parameters?, completionHandler: @escaping (Data) -> Void) {
		makeRequest(url: url, method: .post, encoding: nil, parameters: parameters, headers: nil, completionHandler: completionHandler)
	}
	
}
