//
//  DeletePostAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DeletePostAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var post: Story = .any

    override func setUp() {
        super.setUp()
        provider = DeletePostAPIProvider(story: post)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .DELETE)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/posts/\(post.id)/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

    func testContentType() {
        XCTAssertEqual(provider.contentType, .json)
    }

}
