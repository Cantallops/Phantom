//
//  AddTagAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class AddTagAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var tag: Tag = .any

    override func setUp() {
        super.setUp()
        provider = AddTagAPIProvider(tag: tag)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .POST)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/tags/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

    func testUseClientKeys() {
        XCTAssertFalse(provider.useClientKeys)
    }

    func testContentType() {
        XCTAssertEqual(provider.contentType, .json)
    }

    func testParams() {
        XCTAssertNotNil(provider.parameters["tags"])
    }

}
