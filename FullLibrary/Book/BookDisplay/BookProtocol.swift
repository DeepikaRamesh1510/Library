//
//  DisplayBookDelegate.swift
//  FullLibrary
//
//  Created by user on 06/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation


protocol BookProtocol {
    func performAction(flowType: FlowState, book: Book)
}
