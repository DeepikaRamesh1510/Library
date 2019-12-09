//
//  DisplayBookDelegate.swift
//  FullLibrary
//
//  Created by user on 06/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation


protocol BookProtocol: class {
    func performAction(flowState: FlowState, book: Book)
}
