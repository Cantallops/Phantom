//
//  SubscribersAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class SubscribersAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!

    override func setUp() {
        super.setUp()
        provider = SubscribersAPIProvider()
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .GET)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/subscribers/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

    func testParams() {
        XCTAssertEqual(provider.parameters["limit"] as? String, "all")
    }

}
