//
//  UITableViewSectionTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 13/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class UITableViewSectionTest: XCTestCase {

    var section: UITableView.Section!

    func testDefaultValues() {
        section = UITableView.Section(cells: [])
        XCTAssertNil(section.header)
        XCTAssertNil(section.footer)
    }

}
