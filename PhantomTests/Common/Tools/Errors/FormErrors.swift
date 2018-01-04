//
//  FormErrors.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class FormErrors: XCTestCase {

    func testNotFilledHasDescription() {
        XCTAssertEqual(Errors.Form.notFilled.localizedDescription, "Please fill out the form")
    }

}
