//
//  DoBiometricSignIn.swift
//  Phantom
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

extension Errors {
    enum Biometric: Error {
        case notImplemented
    }
}

class DoBiometricSignIn: Interactor<Any?, Any?> {
    override func execute(args: Any?) -> Result<Any?> {
        return Result.failure(Errors.Biometric.notImplemented)
    }
}
