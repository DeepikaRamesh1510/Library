//
//  Constants.swift
//  FullLibrary
//
//  Created by user on 03/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
//import FullAuthIOSClient


let session = URLSession.shared

struct OAuthInstance {
    let clientID = "23703-a89f03d3af0eeac138fe"
    let clientSecret = "-ikVprSPe-oSOjLx1HdhknNWOoQrULGqv10twoHn"
    let baseURL = URL(string: "https://anywhere.fullauth.com")
    let redirectURI = "com.fullcreative.fullbooks://oauth2callback"
    let scopes = ["awapis.identity", "awapis.account.read"]
    
//    func getAuthcodeUrl() -> URL? {
    
//        let request = FullAuthOAuthService(liveMode: false, authDomain: "anywhere", clientId: "23703-a89f03d3af0eeac138fe", clientSecret: "-ikVprSPe-oSOjLx1HdhknNWOoQrULGqv10twoHn")
        
        
//    }
    
    func getCodeByProvidingTheClientID() {
        guard var authRequestUrl = baseURL else {
            print("Failed to build base URL")
            return
        }
        authRequestUrl = authRequestUrl.appendingPathComponent("/o/oauth2/auth")
        authRequestUrl = authRequestUrl.appendQueryItem(name: "response_type", value: "code") ?? authRequestUrl
        authRequestUrl = authRequestUrl.appendQueryItem(name: "client_id", value: clientID) ?? authRequestUrl
        authRequestUrl = authRequestUrl.appendQueryItem(name: "redirect_uri", value: redirectURI) ?? authRequestUrl
        var scopeString = String()
        for scope in scopes {
            scopeString += scope
        }
        authRequestUrl = authRequestUrl.appendQueryItem(name: "scope", value: scopeString) ?? authRequestUrl
        let dataTask = session.dataTask(with: authRequestUrl) { (data, response,error) in
            guard let response = response as? HTTPURLResponse else {
                print("No response from the server")
                return
            }
            guard response.statusCode == 200 else {
                print("Status code: \(response.statusCode), description: \(response.description)")
                return
            }
//            print(data)
        }
        dataTask.resume()
    }
}
