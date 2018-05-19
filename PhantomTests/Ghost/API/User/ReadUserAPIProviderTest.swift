//
//  ReadUserAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class ReadUserAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var id: String = "me"

    override func setUp() {
        super.setUp()
        provider = ReadUserAPIProvider(id: id)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .GET)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/users/\(id)/")
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
    }

}
