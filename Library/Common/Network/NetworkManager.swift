//
//  NetworkManager.swift
//  FullLibrary
//
//  Created by user on 10/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import Alamofire


class NetworkManager {
	//	let shared = NetworkManager()
	//	init() { }
	
	//MARK: Generic network request
	
	let validationClosure = { (resquest: URLRequest?, response: HTTPURLResponse, data: Data?) -> Request.ValidationResult in
		let statusCode = response.statusCode
		switch statusCode {
			case 200..<300:
				return .success(())
			case 400..<500:
				return .failure(HTTPResponseError.clientError)
			case 500..<600:
				return .failure(HTTPResponseError.serverError)
			default:
				return .failure(HTTPResponseError.undefined)
		}
	}
	
//	func downloadFile(fileURL: String, completionHandler: @escaping (Data?, Error?) -> Void) {
//		DispatchQueue.main.async {
//			Alamofire.download("https://httpbin.org/image/png").responseData { response in
//				if let data = response.value {
//					completionHandler(data, nil)
//				}
//			}
//		}
		
//		Alamofire.download(fileURL).responseData { response in
//			switch response.result {
//				case .success:
//					guard let data = response.value else {
//						print("Data not received!")
//						return
//					}
//					completionHandler(data, nil)
//				case let .failure(error):
//					completionHandler(nil, error)
//			}
//		}
//	}
	
	func makeRequest(url: URLConvertible, method: HTTPMethod,encoding: ParameterEncoding?,parameters: Parameters?, headers: HTTPHeaders?, completionHandler:@escaping (Data?, Error?) -> Void ) {
		let parameterEncoding = encoding ?? URLEncoding.default
		AF.request(url, method: method, parameters: parameters, encoding: parameterEncoding, headers: headers).validate(validationClosure).responseData { response in
			switch response.result {
				case .success:
					guard let data = response.data else {
						print("Data not received!")
						return
					}
					completionHandler(data, nil)
				case let .failure(error):
					completionHandler(nil, error)
			}
		}
	}
	
	//MARK: Get requests
	
	//get request with all the encoding, parameters and headers
	func getRequest(url: URLConvertible, encoding: ParameterEncoding?,parameters: Parameters?, headers: HTTPHeaders?, completionHandler: @escaping (Data?, Error?) -> Void) {
		makeRequest(url: url, method: .get, encoding: encoding, parameters: parameters, headers: headers, completionHandler: completionHandler)
	}
	
	//MARK: Post Request
	//Post request with all the encoding, parameters and headers
	func postRequest(url: URLConvertible, encoding: ParameterEncoding?,parameters: Parameters?, headers: HTTPHeaders?, completionHandler: @escaping (Data?, Error?) -> Void) {
		makeRequest(url: url, method: .post, encoding: encoding, parameters: parameters, headers: headers, completionHandler: completionHandler)
	}
}
