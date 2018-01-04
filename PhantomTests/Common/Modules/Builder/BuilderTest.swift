//
//  BuilderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class BuilderTest: XCTestCase {
    func testFatalErrorBuild() {
        let builder = Builder<Any?, Any?>()
        expectFatalError(expectedMessage: "You should implement in a subclass") {
            _ = builder.build(arg: nil)
        }
    }
}
