//
//  ButtonLoaderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class ButtonLoaderTest: XCTestCase {

    fileprivate var button: Button!

    override func setUp() {
        super.setUp()
        button = Button()
    }

    func testShouldAddSpinnerWhenLoadAndRemoveWhenStop() {
        XCTAssertNil(button.viewWithTag(9876))
        button.start()
        guard let activeSpinner = button.viewWithTag(9876) as? UIActivityIndicatorView else {
            XCTFail("Should have a activity indicator")
            return
        }
        XCTAssertTrue(activeSpinner.isAnimating)
        button.stop()
        XCTAssertNil(button.viewWithTag(9876))
    }

}
