//
//  ToastForViewController.swift
//  FullLibrary
//
//  Created by user on 06/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	
	func showToast(message : String) {
		let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: self.view.frame.size.width - 40, height: 35))
		toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		toastLabel.textColor = UIColor.white
		toastLabel.textAlignment = .center;
		toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
		toastLabel.text = message
		toastLabel.alpha = 1.0
		toastLabel.layer.cornerRadius = 10;
		toastLabel.clipsToBounds  =  true
		self.view.addSubview(toastLabel)
		UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
			toastLabel.alpha = 0.0
		}, completion: {(isCompleted) in
			toastLabel.removeFromSuperview()
		})
	}
	
	func dismissViewController() {
		self.dismiss(animated: true, completion: nil)
	}
	
	func showAlert(title: String, message: String, actions: [UIAlertAction]) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		for action in actions {
			alert.addAction(action)
		}
		self.present(alert, animated: true, completion: nil)
	}
}

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

extension UITextView {
	func displayLoadingSpinner() {
		let spinner =  UIActivityIndicatorView(style: .medium)
		spinner.color = .systemGray
		spinner.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
		spinner.startAnimating()
		self.addSubview(spinner)
	}
	
	func removeLoaderFromDisplay() {
		for subView in self.subviews {
			guard let spinner = subView as? UIActivityIndicatorView else {
				continue
			}
			spinner.removeFromSuperview()
		}
	}
}

