//
//  NetworkExtensions.swift
//  FullLibrary
//
//  Created by user on 03/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

extension URL {
    func appendQueryItem(name: String, value: String) -> URL? {
        guard var urlComponent = URLComponents.init(string: absoluteString) else {
            return absoluteURL
        }
        var queryItems = urlComponent.queryItems ?? []
        queryItems.append(URLQueryItem(name: name, value: value))
        urlComponent.queryItems = queryItems
        return urlComponent.url
    }
}
