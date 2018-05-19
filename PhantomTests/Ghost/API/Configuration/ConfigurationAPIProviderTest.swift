//
//  ConfigurationAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 19/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class ConfigurationAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!

    override func setUp() {
        super.setUp()
        provider = ConfigurationAPIProvider(baseUrl: "base.com", versioning: "v1")
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .GET)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/configuration")
    }

    func testAuthenticated() {
        XCTAssertFalse(provider.authenticated)
    }
}
