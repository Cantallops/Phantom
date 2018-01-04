//
//  DoBiometricSignInTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DoBiometricSignInTest: XCTestCase {
    fileprivate var interactor: DoBiometricSignIn!

    override func setUp() {
        super.setUp()
        interactor = DoBiometricSignIn()
    }

    func testShouldFailureBecauseIsNotImplemented() {
        let result = interactor.execute(args: nil)
        switch result {
        case .failure(let error):
            XCTAssertTrue(error is Errors.Biometric)
        default:
            XCTFail("Should failure")
        }
    }

}
