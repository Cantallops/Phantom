//
//  DoCredentialSignInTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DoCredentialSignInTest: XCTestCase {

    fileprivate var interactor: DoCredentialSignIn!
    fileprivate var getOauthDataSource: MockDataSource<Credentials, Oauth>!
    fileprivate let credentials = Credentials(email: "email", password: "pass")
    fileprivate let oauth = Oauth(
        accessToken: "access",
        refreshToken: "refresh",
        expiresIn: 1,
        tokenType: "type"
    )

    override func setUp() {
        super.setUp()
        Account.current = .signedout
        getOauthDataSource = MockDataSource<Credentials, Oauth>(result: .success(oauth))
        interactor = DoCredentialSignIn(
            getOauth: getOauthDataSource
        )
    }

    override func tearDown() {
        Account.current = nil
        Account.last = nil
        super.tearDown()
    }

    func testShouldSuccedIfGetOauthReturnsAOauthObject() {
        getOauthDataSource.result = Result.success(oauth)
        expectation(
            forNotification: NSNotification.Name(rawValue: InternalNotification.signIn.name),
            object: nil,
            handler: nil
        )
        let result = interactor.execute(args: credentials)
        XCTAssertTrue(result.isSuccess)
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testShouldFailureIfCantGetOauth() {
        getOauthDataSource.result = Result.failure(TestError())
        let result = interactor.execute(args: credentials)
        XCTAssertTrue(result.error is TestError)
    }
}
