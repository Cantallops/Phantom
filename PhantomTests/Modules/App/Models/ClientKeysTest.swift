//
//  ClientKeysTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class ClientKeysTest: XCTestCase {

    func testBlogConfigurationShouldReturnClientKeys() {
        let clientId = "clientId"
        let clientSecret = "clientSecret"
        let blogConfiguration = BlogConfiguration(
            blogUrl: "any blog url",
            blogTitle: "any title",
            clientId: clientId,
            clientSecret: clientSecret
        )
        let clientKeys = blogConfiguration.clientKeys
        XCTAssertEqual(clientKeys.id, clientId)
        XCTAssertEqual(clientKeys.secret, clientSecret)
    }

}
