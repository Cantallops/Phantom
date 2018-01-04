//
//  DashboardFactoryTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 28/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DashboardFactoryTest: XCTestCase {
    fileprivate var factory: Factory<UIViewController>!

    override func setUp() {
        super.setUp()
        factory = DashboardFactory()
    }

    func testBuild() {
        let view = factory.build()
        guard let viewController = view as? DashboardView else {
            XCTFail("Should return an instance of Should return an instance of")
            return
        }
        XCTAssertTrue(
            type(of: viewController.presenter) == DashboardPresenter.self,
            "Presenter should be an instance of DashboardPresenter"
        )
    }
}
