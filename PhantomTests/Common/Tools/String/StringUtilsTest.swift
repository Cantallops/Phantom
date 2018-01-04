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

    func testCalculateHeight() {
        let string = "Hi my name is Alberto, what is your name?"
        let height = string.height(withConstrainedWidth: 100, font: .systemFont(ofSize: 17))
        XCTAssertEqual(height, 82)
    }

}
