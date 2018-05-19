//
//  ReadPostAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class ReadPostAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var postID: String = "id"

    override func setUp() {
        super.setUp()
        provider = ReadPostAPIProvider(id: postID)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .GET)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/posts/\(postID)/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

    func testContentType() {
        XCTAssertEqual(provider.contentType, .json)
    }

    func testQueryParams() {
        let params = provider.queryParameters
        XCTAssertEqual(params["include"] as? String, "author,tags")
        XCTAssertEqual(params["status"] as? String, "all")
        XCTAssertEqual(params["formats"] as? String, "mobiledoc,html")
    }

}
