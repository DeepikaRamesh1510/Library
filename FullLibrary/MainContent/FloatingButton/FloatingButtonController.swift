//
//  FloatingButtonController.swift
//  FullLibrary
//
//  Created by user on 10/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class FloatingButtonController: UIViewController {

	var floatingButton: UIButton!
	let floatingWindow = FloatingWindow()
	
	init() {
	super.init(nibName: nil, bundle: nil)
		floatingWindow.windowLevel = UIWindow.Level(rawValue: CGFloat.greatestFiniteMagnitude)
		floatingWindow.isHidden = false
		floatingWindow.rootViewController = self
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
	override func loadView() {
		super.loadView()
		let floatingButton = UIButton(frame: CGRect(x: floatingWindow.bounds.maxX - 70, y: floatingWindow.bounds.maxY - 130, width: 50, height: 50))
		floatingButton.setImage(UIImage(named: ImageAssets.plus.rawValue), for: .normal)
		floatingButton.backgroundColor = UIColor.systemYellow
		floatingButton.layer.cornerRadius = floatingButton.bounds.height / 2
		floatingButton.addTarget(self, action: #selector(presentBookViewController), for: .touchUpInside)
		view.addSubview(floatingButton)
		self.floatingButton = floatingButton
		floatingWindow.button = floatingButton
	}
	
	@objc func presentBookViewController() {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		guard let bookViewController = storyboard.instantiateViewController(withIdentifier: ViewController.bookViewController.rawValue) as? BookViewController else {
			self.showToast(message: "Failed to open!")
			return
		}
		self.present(bookViewController, animated: true, completion: nil)
	}

}
