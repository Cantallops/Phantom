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

    func testBuildForPhone() {
        let factory = DashboardFactory(device: PhoneDeviceMock())
        let view = factory.build()
        guard let viewController = view as? DashboardView else {
            XCTFail("Should return an instance of DashboardView instead of \(type(of: view))")
            return
        }
        XCTAssertTrue(
            type(of: viewController.presenter) == DashboardPresenter.self,
            "Presenter should be an instance of DashboardPresenter"
        )
    }

    func testBuildForTablet() {
        let factory = DashboardFactory(device: PadDeviceMock())
        let view = factory.build()
        guard let viewController = view as? TabletDashboardView else {
            XCTFail("Should return an instance of TabletDashboardView instead of \(type(of: view))")
            return
        }
        XCTAssertTrue(
            type(of: viewController.presenter) == TabletDashboardPresenter.self,
            "Presenter should be an instance of TabletDashboardPresenter"
        )
    }
}
