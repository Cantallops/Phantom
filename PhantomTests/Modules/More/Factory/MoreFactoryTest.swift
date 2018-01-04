//
//  MoreFactoryTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 28/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class MoreFactoryTest: XCTestCase {
    fileprivate var factory: Factory<UIViewController>!

    override func setUp() {
        super.setUp()
        factory = MoreFactory()
    }

    func testBuild() {
        XCTAssertViewFactory(
            factory,
            expectedViewClass: MoreView.self,
            expectedPresenterClass: MorePresenter.self
        )
    }
}
