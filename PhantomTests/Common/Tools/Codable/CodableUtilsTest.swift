//
//  CodableUtilsTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest

class CodableUtilsTest: XCTestCase {

    func testDecodeWithDate() throws {
        let json = [
            "date": "01-02-1994 12:12",
            "string": "hi"
        ]
        let data = try JSONSerialization.data(withJSONObject: json, options: [])
        let decodedObject = try CodableTestStruct.decode(data, dateFormat: "dd-MM-yyyy HH:mm")
        XCTAssertEqual(decodedObject.string, "hi")
    }

}

struct CodableTestStruct: Codable {
    let date: Date
    let string: String
}
