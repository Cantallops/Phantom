//
//  TextFieldTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 11/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class TextFieldTest: XCTestCase {

    fileprivate var textField: TextField!

    override func setUp() {
        super.setUp()
        textField = TextField()
    }

    func testShouldHasInitialValue() {
        XCTAssertEqual(textField.delegate as? TextField, textField)
        XCTAssertEqual(textField.layer.cornerRadius, 4)
        XCTAssertEqual(textField.layer.borderWidth, 1)
        XCTAssertEqual(textField.layer.borderColor, Color.border.cgColor)
        XCTAssertTrue(textField.clipsToBounds)
    }

    func testReturn() {
        var called = false
        textField.onReturn = {
            called = true
        }
        _ = textField.textFieldShouldReturn(textField)
        XCTAssertTrue(called)
    }

    func testSetError() {
        XCTAssertEqual(textField.layer.borderColor, Color.border.cgColor)
        textField.setError()
        XCTAssertEqual(textField.layer.borderColor, Color.red.cgColor)
    }

    func testSetErrorCalledMoreThanOnceInARow() {
        XCTAssertEqual(textField.layer.borderColor, Color.border.cgColor)
        textField.setError()
        XCTAssertEqual(textField.layer.borderColor, Color.red.cgColor)
        textField.setError()
        XCTAssertEqual(textField.layer.borderColor, Color.red.cgColor)
        textField.dismissError()
        XCTAssertEqual(textField.layer.borderColor, Color.border.cgColor)
    }

    func testDismissError() {
        textField.setError()
        XCTAssertEqual(textField.layer.borderColor, Color.red.cgColor)
        textField.dismissError()
        XCTAssertEqual(textField.layer.borderColor, Color.border.cgColor)
    }

    func testDismissErrorCalledMoreThanOnceInARow() {
        textField.setError()
        XCTAssertEqual(textField.layer.borderColor, Color.red.cgColor)
        textField.dismissError()
        XCTAssertEqual(textField.layer.borderColor, Color.border.cgColor)
        textField.dismissError()
        XCTAssertEqual(textField.layer.borderColor, Color.border.cgColor)
    }

}
