//
//  NetworkCall.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 19/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class NetworkCall: XCTestCase {

    func testCall() {
        let provider = TestProvider(
            method: .GET,
            parameters: [:],
            baseUrl: "https://blog.ghost.org",
            versioning: "ghost/api/v0.1",
            uri: "configuration"
        )
        let network = Network()
        let response: Result<Data> = network.call(provider: provider)
        XCTAssertTrue(response.isSuccess)
    }

    func testProcessSucced() {
        let network = Network()
        let data = "{\"date\":\"hola\"}".data(using: .utf8)

        let response: Result<Data> = network.process(data: data, response: nil, error: nil)
        XCTAssertTrue(response.isSuccess)
        XCTAssertEqual(response.value, data)
    }

    func testProcessFailure() {
        let network = Network()

        let response: Result<Data> = network.process(data: nil, response: nil, error: NetworkError(kind: .unknown))
        XCTAssertTrue(response.isFailure)
    }

    func testProcessNotDetectErrorNorData() {
        let network = Network()
        let responseExpected = URLResponse()
        let response: Result<Data> = network.process(data: nil, response: responseExpected, error: nil)
        XCTAssertTrue(response.isFailure)
    }
}
