//
//  InteractorTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class InteractorTest: XCTestCase {

    fileprivate var interactor: Interactor<Any, Any>!

    override func setUp() {
        super.setUp()
        interactor = Interactor<Any, Any>()
    }

    func testNotImplemented() {
        let result = interactor.execute(args: "Hi")
        switch result {
        case .success:
            XCTFail("Should return an error")
        case .failure(let error):
            XCTAssertTrue(error is NotImplementedError)
        }
    }

}
