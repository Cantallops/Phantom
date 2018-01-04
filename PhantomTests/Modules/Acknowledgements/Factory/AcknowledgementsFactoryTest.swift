//
//  AcknowledgementsFactoryTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 28/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class AcknowledgementsFactoryTest: XCTestCase {

    fileprivate var factory: Factory<UIViewController>!

    override func setUp() {
        super.setUp()
        factory = AcknowledgementsFactory()
    }

    func testBuild() {
        XCTAssertViewFactory(
            factory,
            expectedViewClass: AcknowledgementsView.self,
            expectedPresenterClass: AcknowledgementsPresenter.self
        )
    }

}
