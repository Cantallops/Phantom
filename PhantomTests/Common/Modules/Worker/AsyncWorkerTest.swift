//
//  AsyncWorkerTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 15/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class AsyncWorkerTest: XCTestCase {

    var worker: AsyncWorker!

    override func setUp() {
        super.setUp()
        worker = AsyncWorker()
    }

    func testShouldCallOnRespectiveThreads() {
        let runBackgroundExpectation = expectation(description: "Run background")
        let runMainExpectation = expectation(description: "Run main")
        let task = Task(task: { () -> Bool in
            runBackgroundExpectation.fulfill()
            XCTAssertFalse(Thread.isMainThread)
            return true
        }, completion: { _ in
            XCTAssertTrue(Thread.isMainThread)
            runMainExpectation.fulfill()
        })
        worker.execute(task: task)
        waitForExpectations(timeout: 0.2)
    }

    func testMainShouldReceiveResultOfBackground() {
        let expectedResult = "hi"
        let runMainExpectation = expectation(description: "Run main")
        let task = Task(task: {
            return expectedResult
        }, completion: { result in
            XCTAssertEqual(result, expectedResult)
            runMainExpectation.fulfill()
        })
        worker.execute(task: task)
        waitForExpectations(timeout: 0.2)
    }
}
