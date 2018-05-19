//
//  SettingsAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class SettingsAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!

    override func setUp() {
        super.setUp()
        provider = SettingsAPIProvider()
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .GET)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/settings/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

}
