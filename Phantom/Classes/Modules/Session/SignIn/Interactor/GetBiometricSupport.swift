//
//  GetBiometricSupport.swift
//  Phantom
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType: Int {
    case none
    case touchID
    case faceID
}

class GetBiometricSupport: Interactor<Any?, BiometricType> {
    override func execute(args: Any?) -> Result<BiometricType> {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil),
            let type = BiometricType(rawValue: context.biometryType.rawValue) {
            return Result.success(type)
        }
        return Result.success(.none)
    }
}
