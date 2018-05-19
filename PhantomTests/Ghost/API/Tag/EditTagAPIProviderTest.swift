//
//  EditTagAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class EditTagAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var tag: Tag = .any

    override func setUp() {
        super.setUp()
        provider = EditTagAPIProvider(tag: tag)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .PUT)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/tags/\(tag.id)/")
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
