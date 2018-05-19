//
//  AboutConfigurationAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 19/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class AboutConfigurationAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!

    override func setUp() {
        super.setUp()
        provider = AboutConfigurationAPIProvider()
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .GET)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/configuration/about/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }
}
