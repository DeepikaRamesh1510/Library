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
	var isVisible: Bool = true {
		willSet {
			if newValue {
				floatingButton.isUserInteractionEnabled = true
				floatingButton.isHidden = false
				return
			}
			floatingButton.isUserInteractionEnabled = false
			floatingButton.isHidden = true
		}
	}
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
		let floatingButton = UIButton(frame: CGRect(x: floatingWindow.bounds.maxX - 70, y: floatingWindow.bounds.maxY - 110, width: 50, height: 50))
		floatingButton.setImage(UIImage(named: ImageAssets.plus.rawValue), for: .normal)
		floatingButton.backgroundColor = UIColor.systemYellow
		floatingButton.layer.cornerRadius = floatingButton.bounds.height / 2
		view.addSubview(floatingButton)
		self.floatingButton = floatingButton
		floatingWindow.button = floatingButton
	}
	
	

}
