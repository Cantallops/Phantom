//
//  DateTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DateTest: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    func testDefaultDateFormat() {
        XCTAssertEqual(Date.defaultFormat, "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
    }

    func testColloquialJustNow() {
        let date = Date(timeIntervalSince1970: 0)
        let sinceDate = Date(timeIntervalSince1970: 0)
        let colloquial = date.colloquial(since: sinceDate)
        XCTAssertEqual(colloquial, "just now")
    }

    func testColloquialTwoDaysAgo() {
        let date = Date(timeIntervalSince1970: 0)
        let sinceDate = Date(timeIntervalSince1970: 60*60*24*2)
        let colloquial = date.colloquial(since: sinceDate)
        XCTAssertEqual(colloquial, "2 days ago")
    }

    func testColloquialAMonthAgo() {
        let date = Date(timeIntervalSince1970: 0)
        let sinceDate = Date(timeIntervalSince1970: 60*60*24*35)
        let colloquial = date.colloquial(since: sinceDate)
        XCTAssertEqual(colloquial, "past month")
    }

    func testGetFormattedDate() {
        let date = Date(timeIntervalSince1970: 0)
        let formattedDate = date.formated(format: "dd/MM/yyyy")
        XCTAssertEqual(formattedDate, "01/01/1970")
    }

    func testGetApiFormattedDate() {
        let date = Date(timeIntervalSince1970: 0)
        let formattedDate = date.apiFormated()
        XCTAssertEqual(formattedDate, "1970-01-01T00:00:00.000Z")
    }
}
