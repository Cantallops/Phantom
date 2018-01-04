//
//  AsyncHelperTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class AsyncHelperTest: XCTestCase {

    func testShouldCallOnRespectiveThreads() {
        let runBackgroundExpectation = expectation(description: "Run background")
        let runMainExpectation = expectation(description: "Run main")
        async(background: { () -> Bool in
            runBackgroundExpectation.fulfill()
            XCTAssertFalse(Thread.isMainThread)
            return true
        }, main: { _ in
            XCTAssertTrue(Thread.isMainThread)
            runMainExpectation.fulfill()
        })
        waitForExpectations(timeout: 0.2)
    }

    func testMainShouldReceiveResultOfBackground() {
        let expectedResult = "hi"
        let runMainExpectation = expectation(description: "Run main")
        async(background: { () -> String in
            return expectedResult
        }, main: { result in
            XCTAssertEqual(result, expectedResult)
            runMainExpectation.fulfill()
        })
        waitForExpectations(timeout: 0.2)
    }
}
