//
//  DebounceTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DebounceTest: XCTestCase {

    func testCall() {
        let runDebounceExpectation = expectation(description: "Run debounce")
        let debounce = Debounce(delay: 0.2) {
            runDebounceExpectation.fulfill()
        }
        debounce.call()
        waitForExpectations(timeout: 0.3)
    }

    func testFire() {
        var called = false
        let debounce = Debounce(delay: 0.2) {
            called = true
        }
        debounce.fire()
        XCTAssertTrue(called)
    }

    func testInvalidate() {
        var called = false
        let debounce = Debounce(delay: 0.2) {
            called = true
            XCTFail("Should not be called")
        }
        debounce.call()
        debounce.invalidate()
        wait(for: [], timeout: 0.2)
        XCTAssertFalse(called)
    }

    func testReset() {
        let runDebounceExpectation = expectation(description: "Run debounce")
        var timesCalled = 0
        let debounce = Debounce(delay: 0.2) {
            timesCalled += 1
            runDebounceExpectation.fulfill()
        }
        debounce.call()
        debounce.reset()
        waitForExpectations(timeout: 0.6)
        XCTAssertEqual(timesCalled, 1)
    }
}
