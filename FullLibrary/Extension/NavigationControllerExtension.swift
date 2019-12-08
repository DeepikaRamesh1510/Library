//
//  Extension+NavigationController.swift
//  FullLibrary
//
//  Created by user on 07/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
extension UINavigationController {
    func changeNavbarTitle(to title: String) {
        self.navigationBar.topItem?.title = title
    }
    
    func changeNavigationBarContent(title: String, rightBarButtons: [UIBarButtonItem]?){
        changeNavbarTitle(to: title)
        self.navigationItem.rightBarButtonItems = rightBarButtons
    }
}
