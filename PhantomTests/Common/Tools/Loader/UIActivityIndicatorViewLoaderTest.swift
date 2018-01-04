//
//  UIActivityIndicatorViewLoaderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 12/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class UIActivityIndicatorViewLoaderTest: XCTestCase {

    private var activityIndicartor: UIActivityIndicatorView!

    override func setUp() {
        super.setUp()
        activityIndicartor = UIActivityIndicatorView()
        XCTAssertFalse(activityIndicartor.isLoading)
    }

    func testStart() {
        activityIndicartor.start()
        XCTAssertTrue(activityIndicartor.isLoading)
    }

    func testStop() {
        activityIndicartor.start()
        activityIndicartor.stop()
        XCTAssertFalse(activityIndicartor.isLoading)
    }
}
