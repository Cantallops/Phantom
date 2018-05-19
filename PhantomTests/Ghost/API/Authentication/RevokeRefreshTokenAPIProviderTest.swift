//
//  RevokeRefreshTokenAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class RevokeRefreshTokenAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var oauth: Oauth!

    override func setUp() {
        super.setUp()
        oauth = Oauth(accessToken: "access", refreshToken: "refressh", expiresIn: 10, tokenType: "type")
        provider = RevokeRefreshTokenAPIProvider(oauth: oauth)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .POST)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/authentication/revoke")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

    func testUseClientKeys() {
        XCTAssertFalse(provider.useClientKeys)
    }

    func testParams() {
        let params = provider.parameters
        XCTAssertEqual(params["tokenTypeHint"] as? String, "refresh_token")
        XCTAssertEqual(params["token"] as? String, oauth.refreshToken)
    }

}
