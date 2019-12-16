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
		let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
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

extension UIImage {
//	 convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
//		   let rect = CGRect(origin: .zero, size: size)
//		   UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
//		   color.setFill()
//		   UIRectFill(rect)
//		   let image = UIGraphicsGetImageFromCurrentImageContext()
//		   UIGraphicsEndImageContext()
//
//		guard let cgImage = image?.cgImage else { return nil }
//		self(cgImage: cgImage)
//	   }
//	static func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
//		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
//		UIGraphicsBeginImageContextWithOptions(size, false, 0)
//		color.setFill()
//		UIRectFill(rect)
//		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
//		UIGraphicsEndImageContext()
//		return image
//	}
}
