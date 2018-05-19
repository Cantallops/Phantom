//
//  OauthAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 19/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class OauthAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var credentials: Credentials!

    override func setUp() {
        super.setUp()
        credentials = Credentials(email: "email@mail.com", password: "password")
        provider = OauthAPIProvider(credentials: credentials)
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
        XCTAssertEqual(params["grant_type"] as? String, "password")
        XCTAssertEqual(params["password"] as? String, credentials.password)
        XCTAssertEqual(params["username"] as? String, credentials.email)
    }

}
