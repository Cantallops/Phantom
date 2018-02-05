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
        XCTAssertEqual(result.value!, expectedResult)
    }

    func testResultInitShoulInitializeWithFailure() {
        let result = Result {
            throw TestError()
        }
        XCTAssertTrue(result.error! is TestError)
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

    func testGetValue() {
        let expectedResult = "Hi"
        let result = Result.success(expectedResult)
        XCTAssertEqual(result.value, expectedResult)
        XCTAssertNil(result.error)
    }

    func testGetError() {
        let error = TestError()
        let result = Result<String>.failure(error)
        XCTAssertNotNil(result.error)
        XCTAssertNil(result.value)
    }

    func testCombinedResultSuccessAndSuccess() {
        let expectedResult1 = "1"
        let expectedResult2 = "2"
        let result1 = Result.success(expectedResult1)
        let result2 = Result.success(expectedResult2)
        let combinedResult = result1.combined(result: result2)
        XCTAssertTrue(combinedResult.isSuccess)
        XCTAssertEqual(combinedResult.value!.0, expectedResult1)
        XCTAssertEqual(combinedResult.value!.1, expectedResult2)
    }

    func testCombinedResultSuccessAndError() {
        let expectedResult1 = "1"
        let error = TestError()
        let result1 = Result.success(expectedResult1)
        let result2 = Result<String>.failure(error)
        let combinedResult = result1.combined(result: result2)
        XCTAssertTrue(combinedResult.isFailure)
        XCTAssertNotNil(combinedResult.error)
    }

    func testCombinedResultErrorAndSuccess() {
        let expectedResult2 = "2"
        let error = TestError()
        let result1 = Result<String>.failure(error)
        let result2 = Result.success(expectedResult2)
        let combinedResult = result1.combined(result: result2)
        XCTAssertTrue(combinedResult.isFailure)
        XCTAssertNotNil(combinedResult.error)
    }

    func testCombinedResultErrorAndError() {
        let error1 = TestError(localizedDescription: "Error 1")
        let error2 = TestError(localizedDescription: "Error 2")
        let result1 = Result<String>.failure(error1)
        let result2 = Result<String>.failure(error2)
        let combinedResult = result1.combined(result: result2)
        XCTAssertTrue(combinedResult.isFailure)
        XCTAssertTrue(combinedResult.error is CombinedError)
        XCTAssertEqual(combinedResult.error?.localizedDescription, "Error 1\nError 2")
    }
}
