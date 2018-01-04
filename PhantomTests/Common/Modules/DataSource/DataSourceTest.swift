//
//  DataSourceTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DataSourceTest: XCTestCase {

    fileprivate var dataSource: DataSource<Any, Any>!

    override func setUp() {
        super.setUp()
        dataSource = DataSource<Any, Any>()
    }

    func testNotImplemented() {
        let result = dataSource.execute(args: "Hi")
        switch result {
        case .success:
            XCTFail("Should return an error")
        case .failure(let error):
            XCTAssertTrue(error is NotImplementedError)
        }
    }

}
