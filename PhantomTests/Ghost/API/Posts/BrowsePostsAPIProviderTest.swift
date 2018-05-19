//
//  BrowsePostsAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class BrowsePostsAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!

    override func setUp() {
        super.setUp()
        provider = BrowsePostsAPIProvider(authorToFilter: nil)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .GET)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/posts/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

    func testUseClientKeys() {
        XCTAssertFalse(provider.useClientKeys)
    }

    func testParams() {
        let params = provider.parameters
        XCTAssertEqual(params["limit"] as? String, "all")
        XCTAssertEqual(params["status"] as? String, "all")
        XCTAssertEqual(params["staticPages"] as? String, "all")
        XCTAssertEqual(params["include"] as? String, "author,tags")
        XCTAssertEqual(params["formats"] as? String, "mobiledoc,html,plaintext")
    }

    func testParamWithFilter() {
        let provider = BrowsePostsAPIProvider(authorToFilter: "filter")
        let params = provider.parameters
        XCTAssertEqual(params["limit"] as? String, "all")
        XCTAssertEqual(params["status"] as? String, "all")
        XCTAssertEqual(params["staticPages"] as? String, "all")
        XCTAssertEqual(params["include"] as? String, "author,tags")
        XCTAssertEqual(params["formats"] as? String, "mobiledoc,html,plaintext")
        XCTAssertEqual(params["filter"] as? String, "author:filter")
    }

}
