//
//  UploadFileAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class UploadFileAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var file: File!

    override func setUp() {
        super.setUp()
        file = File(mimeType: "mime", data: Data(), path: "path", name: "name")
        provider = UploadFileAPIProvider(file: file)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .POST)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/uploads/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

    func testContentType() {
        XCTAssertEqual(provider.contentType, .multipart)
    }

    func testFileToUpload() {
        XCTAssertEqual(provider.fileToUpload?.name, file.name)
    }

}
