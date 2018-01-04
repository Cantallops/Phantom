//
//  DetectGhostInstallationTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DetectGhostInstallationTest: XCTestCase {

    fileprivate var interactor: DetectGhostInstallation!
    fileprivate var confDataSource: MockDataSource<(String, String), BlogConfiguration>!
    fileprivate let blogConf = BlogConfiguration(
        blogUrl: "blog.ghost.org",
        blogTitle: "Title",
        clientId: "",
        clientSecret: ""
    )

    override func setUp() {
        super.setUp()
        confDataSource = MockDataSource<(String, String), BlogConfiguration>(
            result: Result.success(blogConf)
        )
        interactor = DetectGhostInstallation(
            blogConfigurationDataSource: confDataSource
        )
    }

    override func tearDown() {
        Account.last = nil
        Account.current = nil
        super.tearDown()
    }

    func testShouldReturnATitleIfDataSourceReturnAConf() {
        confDataSource.result = Result.success(blogConf)
        let result = interactor.execute(args: URL(string: "blog.ghost.org")!)
        XCTAssertEqual(result.value, blogConf.blogTitle)
    }

    func testShouldReturnFailureIfDataSourceReturnError() {
        confDataSource.result = Result.failure(TestError())
        let result = interactor.execute(args: URL(string: blogConf.blogUrl)!)
        XCTAssertTrue(result.error is TestError)
    }

    func testShouldGetLastAccountUsername() {
        Account.last = .signedout
        Account.last?.blogUrl = blogConf.blogUrl
        Account.current = nil
        confDataSource.result = Result.success(blogConf)
        _ = interactor.execute(args: URL(string: blogConf.blogUrl)!)
        XCTAssertFalse(Account.current!.username.isEmpty)
        XCTAssertEqual(Account.current!.username, Account.last!.username)
    }
}
