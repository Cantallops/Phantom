//
//  URLHttpTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class URLHttpTest: XCTestCase {

    func testShouldAddHttpIfItHasNoHttpAndHttps() {
        let url = URL(string: "blog.ghost.org")
        XCTAssertEqual(url?.absoluteStringWithHttp, "http://blog.ghost.org")
    }

    func testShouldNotAddHttpIfItHasHttp() {
        let url = URL(string: "http://blog.ghost.org")
        XCTAssertEqual(url?.absoluteStringWithHttp, "http://blog.ghost.org")
    }

    func testShouldNotAddHttpIfItHasHttps() {
        let url = URL(string: "https://blog.ghost.org")
        XCTAssertEqual(url?.absoluteStringWithHttp, "https://blog.ghost.org")
    }
}
