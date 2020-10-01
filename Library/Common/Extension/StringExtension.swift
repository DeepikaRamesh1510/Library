//
//  ValidationExtension.swift
//  FullLibrary
//
//  Created by user on 03/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

extension String {
    var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
	
    var isValidPassword: Bool {
        guard self.count > 4 else {
            return false
        }
        return true
    }
	
	var length: Int {
		return self.count
	}
	
	var toInt16: Int16? {
		return Int16(self)
	}
	
	var isNotEmpty: Bool {
		return !self.isEmpty
	}
}

extension Optional where Wrapped == String {
	var toInt16: Int16? {
		return self?.toInt16 ?? 0
	}
}
