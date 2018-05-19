//
//  BrowseUsersAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class BrowseUsersAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!

    override func setUp() {
        super.setUp()
        provider = BrowseUsersAPIProvider()
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .GET)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/users/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

    func testUseClientKeys() {
        XCTAssertFalse(provider.useClientKeys)
    }

    func testParams() {
        let params = provider.parameters
        XCTAssertEqual(params["include"] as? String, "roles")
        XCTAssertEqual(params["limit"] as? String, "all")
    }
}
