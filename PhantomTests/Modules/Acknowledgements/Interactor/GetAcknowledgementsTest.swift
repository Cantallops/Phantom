//
//  GetAcknowledgementsTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 28/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class GetAcknowledgementsTest: XCTestCase {

    fileprivate var interactor: GetAcknowledgementsInteractor!

    override func setUp() {
        super.setUp()
        interactor = GetAcknowledgementsInteractor()
    }

    override func tearDown() {
        Account.last = nil
        Account.current = nil
        super.tearDown()
    }

    func testShouldReturnThreeAcknowledgements() {
        let result = interactor.execute(args: nil)
        XCTAssertEqual(result.value?.count, 8)
    }

    func testNoAcknowledgementsPath() {
        interactor.acknowledgementsResoursePath = nil
        let result = interactor.execute(args: nil)
        XCTAssertEqual(result.value?.count, 0)
    }

}
