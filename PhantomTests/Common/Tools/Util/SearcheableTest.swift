//
//  SearcheableTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 26/04/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class SearcheableTest: XCTestCase {

    let searcheable: [SearcheableFake] = [
        SearcheableFake(terms: ["Term"]),
        SearcheableFake(terms: ["A", "Second", "term"]),
        SearcheableFake(terms: ["Thrid", "title"])
    ]

    func testSearchWithResults() {
        let result = searcheable.search(text: "term")
        XCTAssertEqual(result.count, 2)
    }

    func testSearchWithoutResults() {
        let result = searcheable.search(text: "hi")
        XCTAssertTrue(result.isEmpty)
    }

}

struct SearcheableFake: Searcheable {
    var terms: [String]
    func searchTerms() -> [String] {
        return terms
    }
}
