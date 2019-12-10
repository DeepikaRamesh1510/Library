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
    case bookDetailViewController = "BookDetailViewController"
    case bookTableViewController = "BookStaticTableViewController"
    case bookListViewController = "BookListViewController"
	case loginViewController = "LoginViewController"
	case bookViewController = "BookViewController"
	case floatingButtonController = "FloatingButtonController"
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
