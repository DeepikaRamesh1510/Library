//
//  TableViewControllerExtension.swift
//  FullLibrary
//
//  Created by user on 14/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit


extension UITableView {
	func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 2
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }
	func displayLoadingSpinner() {
		let spinner = UIActivityIndicatorView(style: .medium)
		spinner.color = .systemGray
		spinner.startAnimating()
		spinner.frame = CGRect(x: 0, y: 0, width: 20, height: 0)
		spinner.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
		self.backgroundView = spinner
		self.separatorStyle = .none
		
	}

	func setTableViewFooter(view: UIView = UIView()) {
		self.tableFooterView = view
	}
	
	func dismissTableViewOnDrag() {
		self.keyboardDismissMode = .onDrag
	}
	
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
