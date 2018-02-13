//
//  BundleTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 13/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class BundleTest: XCTestCase {

    var bundle: Bundle!

    override func setUp() {
        super.setUp()
        bundle = .main
    }

    func testAppName() {
        XCTAssertEqual(bundle.appName, "Phantom")
    }

    func testVersionNumber() {
        XCTAssertEqual(bundle.versionNumber, "1.0.3")
    }

    func testBuildNumber() {
        XCTAssertEqual(bundle.buildNumber, "1.0.3.1")
    }
}
