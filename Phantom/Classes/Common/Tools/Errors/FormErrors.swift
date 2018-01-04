//
//  FormErrors.swift
//  Phantom
//
//  Created by Alberto Cantallops on 21/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct Errors {
    enum Form: Error {
        case notFilled
    }
}

extension Errors.Form: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notFilled:
            return "Please fill out the form"
        }
    }
}
