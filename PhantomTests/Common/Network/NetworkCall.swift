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
        let network = Network(provider: provider)
        let response: Result<Data> = network.call()
        XCTAssertTrue(response.isSuccess)
    }

    func testProcessSucced() {
        let network = Network(provider: TestProvider())
        let data = "{\"date\":\"hola\"}".data(using: .utf8)

        let response: Result<Data> = network.process(data: data, response: nil, error: nil)
        XCTAssertTrue(response.isSuccess)
        switch response {
        case .success(let value):
            XCTAssertEqual(value, data)
        default: XCTFail("Should succed")
        }
    }

    func testProcessFailure() {
        let network = Network(provider: TestProvider())

        let response: Result<Data> = network.process(data: nil, response: nil, error: NetworkError(kind: .unknown))
        XCTAssertTrue(response.isFailure)
    }

    func testProcessNotDetectErrorNorData() {
        let network = Network(provider: TestProvider())
        let responseExpected = URLResponse()
        let response: Result<Data> = network.process(data: nil, response: responseExpected, error: nil)
        XCTAssertTrue(response.isFailure)
    }
}
