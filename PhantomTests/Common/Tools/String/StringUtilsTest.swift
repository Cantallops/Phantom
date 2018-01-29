//
//  StringUtilsTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest

class StringUtilsTest: XCTestCase {

    func testReplacing() {
        let string = "Hi my name is Alberto, what is your name?"
        let replaced = string.replacing("name", "nickname")
        XCTAssertEqual(replaced, "Hi my nickname is Alberto, what is your nickname?")
    }

    func testTrunc() {
        let string = "Hi my name is Alberto, what is your name?"
        let truncated = string.trunc(length: 10)
        XCTAssertEqual(truncated, "Hi my name…")
    }

    func testTruncWithLengthHigherThanTextsLength() {
        let string = "Hi my name is Alberto, what is your name?"
        let truncated = string.trunc(length: 1000)
        XCTAssertEqual(truncated, string)
    }

    func testCalculateHeight() {
        let string = "Hi my name is Alberto, what is your name?"
        let height = string.height(withConstrainedWidth: 100, font: .systemFont(ofSize: 17))
        XCTAssertEqual(height, 82)
    }

}
