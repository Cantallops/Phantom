//
//  ResultTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class ResultTest: XCTestCase {

    func testResultInitShoulInitializeWithSuccess() {
        let expectedResult = "Hi"
        let result = Result {
            return expectedResult
        }
        switch result {
        case .success(let successResult):
            XCTAssertEqual(successResult, expectedResult)
        default:
            XCTFail("Should initialize as success")
        }
    }

    func testResultInitShoulInitializeWithFailure() {
        let result = Result {
            throw TestError()
        }
        switch result {
        case .failure(let errorResult):
            XCTAssertTrue(errorResult is TestError)
        default:
            XCTFail("Should initialize as failure")
        }
    }

    func testResultIsSuccessShouldReturnTrueAndIsFailureFalse() {
        let expectedResult = "Hi"
        let result = Result.success(expectedResult)
        XCTAssertTrue(result.isSuccess)
        XCTAssertFalse(result.isFailure)
    }

    func testResultIsFailureShouldReturnTrueAndIsSuccessFalse() {
        let result = Result<String>.failure(TestError())
        XCTAssertFalse(result.isSuccess)
        XCTAssertTrue(result.isFailure)
    }
}
