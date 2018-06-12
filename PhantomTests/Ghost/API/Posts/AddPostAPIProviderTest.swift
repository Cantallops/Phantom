//
//  AddPostAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class AddPostAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var post: Story = .any

    override func setUp() {
        super.setUp()
        provider = AddPostAPIProvider(story: post)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .POST)
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

    func testContentType() {
        XCTAssertEqual(provider.contentType, .json)
    }

    func testParams() {
        XCTAssertNotNil(provider.parameters["posts"])
    }

    func testQueryParams() {
        let params = provider.queryParameters
        XCTAssertEqual(params["include"] as? String, "author,authors,tags")
        XCTAssertEqual(params["formats"] as? String, "mobiledoc,html")
    }

}
