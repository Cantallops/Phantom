//
//  LabsFactoryTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 28/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class LabsFactoryTest: XCTestCase {
    fileprivate var factory: Factory<UIViewController>!

    override func setUp() {
        super.setUp()
        factory = LabsFactory()
    }

    func testBuild() {
        XCTAssertViewFactory(
            factory,
            expectedViewClass: LabsView.self,
            expectedPresenterClass: LabsPresenter.self
        )
    }
}
