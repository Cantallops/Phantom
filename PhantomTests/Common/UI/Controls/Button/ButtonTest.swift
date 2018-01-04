//
//  ButtonTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 11/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class ButtonTest: XCTestCase {

    fileprivate var button: Button!

    override func setUp() {
        super.setUp()
        button = Button()
    }

    func testShouldHasInitialValue() {
        XCTAssertEqual(button.layer.cornerRadius, 4)
        XCTAssertTrue(button.clipsToBounds)
        XCTAssertEqual(button.backgroundColor, Color.tint)
        XCTAssertEqual(button.titleColor(for: .normal), Color.white)
    }
}
