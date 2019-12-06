//
//  CRUDError.swift
//  FullLibrary
//
//  Created by user on 06/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation

struct CRUDError: LocalizedError {
    enum ErrorType: String {
        case creationError = "Creation Failed"
        case deletionError = "Deletion Failed"
        case updationError = "Updation Failed"
        case readError = "Failed to Fetch"
        case persistingError = "Failed to Persist"
    }
    var errorDescription: String? { return errorMessage }
    var errorType: ErrorType
    private var errorMessage : String

    init(errorType: ErrorType, errorMessage: String)
    {
        self.errorType = errorType
        self.errorMessage = errorMessage
    }
}
