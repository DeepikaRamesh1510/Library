//
//  Extension+NavigationController.swift
//  FullLibrary
//
//  Created by user on 07/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

extension UINavigationController {

    func changeNavigationBarContent(target: UIViewController,title: String, rightBarButton: UIBarButtonItem){
        target.navigationItem.changeNavbarTitle(to: title)
        target.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationBar.tintColor = UIColor.black
        self.navigationBar.backItem?.title = "Back"
    }
}

extension UINavigationItem {
     func changeNavbarTitle(to title: String?) {
        self.title = title
        }
}
