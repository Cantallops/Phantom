//
//  DeleteTagAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DeleteTagAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var tag: Tag = .any

    override func setUp() {
        super.setUp()
        provider = DeleteTagAPIProvider(tag: tag)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .DELETE)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/tags/\(tag.id)/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

}
