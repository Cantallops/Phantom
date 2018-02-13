//
//  BlogConfigurationTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 13/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class BlogConfigurationTest: XCTestCase {

    var blogConf: BlogConfiguration!

    override func setUp() {
        super.setUp()
        blogConf = BlogConfiguration(
            blogUrl: "blog.ghost.com",
            blogTitle: "Ghost blog",
            clientId: "any",
            clientSecret: "any"
        )
    }

    func testGetFavIcon() {
        let favIconUrl = blogConf.favIconURL
        XCTAssertEqual(favIconUrl?.absoluteString, "blog.ghost.com/favicon.png")
    }

}
