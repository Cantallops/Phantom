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
        let viewController = (view as? DashboardView)!
        XCTAssertTrue(
            type(of: viewController.presenter) == DashboardPresenter.self,
            "Presenter should be an instance of DashboardPresenter"
        )
    }

    func testBuildForTablet() {
        let factory = DashboardFactory(device: PadDeviceMock())
        let view = factory.build()
        let viewController = (view as? TabletDashboardView)!
        XCTAssertTrue(
            type(of: viewController.presenter) == TabletDashboardPresenter.self,
            "Presenter should be an instance of TabletDashboardPresenter"
        )
    }
}
