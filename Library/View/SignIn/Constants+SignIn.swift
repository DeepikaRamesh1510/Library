//
//  Constants.swift
//  FullLibrary
//
//  Created by user on 03/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation


let session = URLSession.shared
let userDefault = UserDefaults.standard
let userDetail = "userDetail"
let isLoggedIn = "isLoggedIn"

enum KeyChainKey: String {
	case accessToken
	case refreshToken
}
//enum UserDefaultKey: String {
//	case isLoggedIn
//	case userName
//	case emailId
//}
//enum GoogleURL: String{
//}

