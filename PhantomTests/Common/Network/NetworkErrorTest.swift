//
//  NetworkErrorTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 12/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class NetworkErrorTest: XCTestCase {

    private var error: NetworkError!

    override func setUp() {
        super.setUp()
        error = NetworkError(kind: .unknown)
    }

    func testErrorCode() {
        let response = HTTPURLResponse(
            url: URL(string: "blog.ghost.org")!,
            statusCode: 402,
            httpVersion: nil,
            headerFields: nil
        )
        let networkResponse = Network.Response(data: nil, response: response, error: nil)
        XCTAssertEqual(networkResponse.statusCode, 402)
    }

    func testErrorCodeNil() {
        let response = URLResponse(
            url: URL(string: "blog.ghost.org")!,
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        let networkResponse = Network.Response(data: nil, response: response, error: nil)
        XCTAssertNil(networkResponse.statusCode)
    }

    func testInitWithResponse401() {
        let response = HTTPURLResponse(
            url: URL(string: "blog.ghost.org")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )
        let networkResponse = Network.Response(data: nil, response: response, error: nil)
        error = NetworkError(response: networkResponse)
        XCTAssertEqual(error.kind, .unauthorized)
        XCTAssertEqual(error.localizedDescription, "Access denied")
    }

    func testInitWithResponseNil() {
        let response = HTTPURLResponse(
            url: URL(string: "blog.ghost.org")!,
            statusCode: 400,
            httpVersion: nil,
            headerFields: nil
        )
        let networkResponse = Network.Response(data: nil, response: response, error: nil)
        XCTAssertNil(NetworkError(response: networkResponse))
    }

    func testInitWithResponseError() {
        let errorText = "ERROR!"
        let networkResponse = Network.Response(
            data: nil,
            response: nil,
            error: TestError(localizedDescription: errorText)
        )
        error = NetworkError(response: networkResponse)!
        XCTAssertEqual(error.localizedDescription, errorText)
    }

    func testInitWithResponseWithGhostErrors() throws {
        let ghostError = GhostError(
            message: "Message",
            context: "Context",
            errorType: NetworkError.Kind.validation.rawValue
        )
        let errors = GhostErrors(errors: [ghostError])
        let data = try JSONEncoder().encode(errors)
        let networkResponse = Network.Response(
            data: data,
            response: nil,
            error: nil
        )
        error = NetworkError(response: networkResponse)!
        XCTAssertEqual(error.localizedDescription, ghostError.message)
    }

    func testGhostErrorKind() {
        let ghostError = GhostError(
            message: "Message",
            context: "Context",
            errorType: NetworkError.Kind.validation.rawValue
        )
        XCTAssertEqual(ghostError.networkErrorKind, .validation)
    }

    func testGhostErrorKindUnknow() {
        let ghostError = GhostError(
            message: "Message",
            context: "Context",
            errorType: "not exist error"
        )
        XCTAssertEqual(ghostError.networkErrorKind, .unknown)
    }

    func testGhostErrorsZero() {
        let errors = GhostErrors(errors: [])
        XCTAssertEqual(errors.networkError, .unknown)
        XCTAssertEqual(errors.message, "")
    }

    func testGhostErrorsOne() {
        let ghostError = GhostError(
            message: "Message",
            context: "Context",
            errorType: NetworkError.Kind.validation.rawValue
        )
        let errors = GhostErrors(errors: [ghostError])
        XCTAssertEqual(errors.networkError, .validation)
        XCTAssertEqual(errors.message, "Message")
    }

    func testGhostErrorsMultiple() {
        let ghostErrorValidation = GhostError(
            message: "Message Validation",
            context: "Context",
            errorType: NetworkError.Kind.validation.rawValue
        )
        let ghostErrorTooManyReq = GhostError(
            message: "Message Too Many Requests",
            context: "Context",
            errorType: NetworkError.Kind.tooManyRequests.rawValue
        )
        let errors = GhostErrors(errors: [ghostErrorValidation, ghostErrorTooManyReq])
        XCTAssertEqual(errors.networkError, .multiple)
        XCTAssertEqual(errors.message, "Message Validation\nMessage Too Many Requests")
    }

    func testIsNotUnauthorizedError() {
        let networError = NetworkError(kind: .validation)
        XCTAssertFalse(networError.isUnauthoriezed)
        let error = TestError()
        XCTAssertFalse(error.isUnauthoriezed)
    }

    func testIsUnauthorizedError() {
        let error = NetworkError(kind: .unauthorized)
        XCTAssertTrue(error.isUnauthoriezed)
    }

    func testIsNotUnauthorizedErrorCombinedError() {
        let validation = NetworkError(kind: .validation)
        let parse = NetworkError(kind: .parse)
        let combinedError = CombinedError(errors: [validation, parse])
        XCTAssertFalse(combinedError.isUnauthoriezed)
    }

    func testIsUnauthorizedErrorCombinedError() {
        let validation = NetworkError(kind: .validation)
        let unauthorized = NetworkError(kind: .unauthorized)
        let combinedError = CombinedError(errors: [validation, unauthorized])
        XCTAssertTrue(combinedError.isUnauthoriezed)
    }
}
