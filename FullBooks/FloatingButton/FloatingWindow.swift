//
//  FloatingWindow.swift
//  FullLibrary
//
//  Created by user on 10/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class FloatingWindow: UIWindow {
	var button: UIButton?
	
	init() {
		super.init(frame: UIScreen.main.bounds)
		backgroundColor = nil
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let button = button else { return false }
		let buttonPoint = convert(point, to: button)
		return button.point(inside: buttonPoint, with: event)
    }


}
