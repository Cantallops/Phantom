//
//  OauthRefreshAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 19/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class OauthRefreshAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var oauth: Oauth!

    override func setUp() {
        super.setUp()
        oauth = Oauth(accessToken: "access", refreshToken: "refressh", expiresIn: 10, tokenType: "type")
        provider = OauthRefreshAPIProvider(oauth: oauth)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .POST)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/authentication/token")
    }

    func testAuthenticated() {
        XCTAssertFalse(provider.authenticated)
    }

    func testUseClientKeys() {
        XCTAssertTrue(provider.useClientKeys)
    }

    func testParams() {
        let params = provider.parameters
        XCTAssertEqual(params["grant_type"] as? String, "refresh_token")
        XCTAssertEqual(params["refresh_token"] as? String, oauth.refreshToken)
    }

}
