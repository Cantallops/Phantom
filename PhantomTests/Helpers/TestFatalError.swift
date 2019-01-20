//
//  TestFatalError.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
import XCTest
@testable import Phantom

extension XCTestCase {
    func expectFatalError(expectedMessage: String, testcase: @escaping () -> Void) {
        let expectation = self.expectation(description: "expectingFatalError")
        var assertionMessage: String? = .none

        FatalErrorUtil.replaceFatalError { message, _, _ in
            assertionMessage = message
            expectation.fulfill()
            repeat {
                RunLoop.current.run()
            } while (true)
        }
        DispatchQueue.global(qos: .userInitiated).async(execute: testcase)

        waitForExpectations(timeout: 0.2) { _ in
            XCTAssertEqual(assertionMessage, expectedMessage)
            FatalErrorUtil.restoreFatalError()
        }
    }
}
