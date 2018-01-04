//
//  NetworkTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 19/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class NetworkTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testGetRequestBuild() {
        let provider = TestProvider()
        let network = Network(provider: provider)

        let request = network.urlRequest
        XCTAssertEqual(request.httpMethod, "GET")
        let url = request.url?.absoluteString
        XCTAssertEqual(url, "https://blog.ghost.org/ghost/api/v0.1/test?param=1")
    }

    func testGetRequestWithMultipleParamsBuild() {
        let provider = TestProvider(parameters: ["param": 1, "p": true])
        let network = Network(provider: provider)

        let request = network.urlRequest
        XCTAssertEqual(request.httpMethod, "GET")
        let url = request.url?.absoluteString
        XCTAssertEqual(url, "https://blog.ghost.org/ghost/api/v0.1/test?p=true&param=1")
    }

    func testGetRequestWithoutParamsBuild() {
        let provider = TestProvider(parameters: [:])
        let network = Network(provider: provider)

        let request = network.urlRequest
        XCTAssertEqual(request.httpMethod, "GET")
        let url = request.url?.absoluteString
        XCTAssertEqual(url, "https://blog.ghost.org/ghost/api/v0.1/test")
    }

    func testPostRequestBuild() {
        let provider = TestProvider(method: .POST)
        let network = Network(provider: provider)

        let request = network.urlRequest
        XCTAssertEqual(request.httpMethod, "POST")
        let url = request.url?.absoluteString
        XCTAssertEqual(url, "https://blog.ghost.org/ghost/api/v0.1/test")
        XCTAssertEqual(request.httpBody, "{\"param\":\"1\"}".data(using: .utf8))
    }

    func testPutRequestBuild() {
        let provider = TestProvider(method: .PUT)
        let network = Network(provider: provider)

        let request = network.urlRequest
        XCTAssertEqual(request.httpMethod, "PUT")
        let url = request.url?.absoluteString
        XCTAssertEqual(url, "https://blog.ghost.org/ghost/api/v0.1/test")
        XCTAssertEqual(request.httpBody, "{\"param\":\"1\"}".data(using: .utf8))
    }

    func testDeleteRequestBuild() {
        let provider = TestProvider(method: .DELETE)
        let network = Network(provider: provider)

        let request = network.urlRequest
        XCTAssertEqual(request.httpMethod, "DELETE")
        let url = request.url?.absoluteString
        XCTAssertEqual(url, "https://blog.ghost.org/ghost/api/v0.1/test")
        XCTAssertEqual(request.httpBody, "{\"param\":\"1\"}".data(using: .utf8))
    }
}
