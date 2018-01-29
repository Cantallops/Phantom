//
//  MetaTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class MetaTest: XCTestCase {

    func testIsFirstPage() {
        let pagination = Meta.Pagination(page: 0, limit: .number(1))
        let metaFirstPage = Meta(pagination: pagination)
        XCTAssertTrue(metaFirstPage.pagination.isFirst)
    }

    func testIsNotFirstPage() {
        let pagination = Meta.Pagination(page: 1, limit: .number(1))
        let metaNotFirstPage = Meta(pagination: pagination)
        XCTAssertFalse(metaNotFirstPage.pagination.isFirst)
    }

    func testPaginationAll() {
        let metaNotFirstPage = Meta(pagination: .all)
        let pagination = metaNotFirstPage.pagination
        XCTAssertTrue(pagination.isFirst)
        XCTAssertEqual(pagination.limit, "all")
    }

    func testPaginationNumber() {
        let pagination = Meta.Pagination(page: 0, limit: .number(1))
        XCTAssertEqual(pagination.limit, "1")
    }

}
