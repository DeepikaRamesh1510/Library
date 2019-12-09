//
//  Config.swift
//  FullLibrary
//
//  Created by user on 07/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation


enum FlowState {
    case update
    case create
}

enum ViewController: String {
	case rootViewController = "RootViewController"
    case bookDetail = "BookDetailVIewController"
    case book = "BookViewController"
    case bookList = "BookListViewController"
	case loginViewController = "LoginViewController"
}

enum TableViewCell: String {
    case book = "BookTableViewCell"
}


enum ImageAssets: String {
	case close
	case book
	case google
	case pencil
	case plus
}
