//
//  NetworkProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class NetworkProviderTest: XCTestCase {

    override func tearDown() {
        Account.current = nil
        Account.last = nil
        super.tearDown()
    }

    func testDefaultProvider() {
        Account.current = nil
        struct TestDefaultProvider: NetworkProvider {
            var method: HTTPMethod = .GET
            var uri: String = "uri"
        }
        let provider = TestDefaultProvider()
        XCTAssertEqual(provider.baseUrl, "")
        XCTAssertEqual(provider.versioning, "")
        Account.current = Account(
            blogUrl: "base",
            apiVersion: "versioning",
            username: "",
            clientKeys: nil,
            oauth: nil
        )
        XCTAssertEqual(provider.method, .GET)
        XCTAssertNil(provider.headers)
        XCTAssertEqual(provider.parameters.count, 0)
        XCTAssertEqual(provider.queryParameters.count, 0)
        XCTAssertEqual(provider.baseUrl, "base")
        XCTAssertEqual(provider.versioning, "versioning")
        XCTAssertEqual(provider.uri, "uri")
        XCTAssertFalse(provider.authenticated)
        XCTAssertFalse(provider.useClientKeys)
        XCTAssertEqual(provider.contentType, .formURLEncoded)
        XCTAssertNil(provider.fileToUpload)
    }

}
