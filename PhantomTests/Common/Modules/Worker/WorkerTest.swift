//
//  WorkerTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 15/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class WorkerTest: XCTestCase {
    func testFatalErrorExecute() {
        let worker = Worker()
        let task = Task(task: {})
        expectFatalError(expectedMessage: "You should implement in a subclass") {
            worker.execute(task: task)
        }
    }
}
