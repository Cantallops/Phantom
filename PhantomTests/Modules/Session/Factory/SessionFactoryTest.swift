//
//  SessionFactoryTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 28/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class SessionFactoryTest: XCTestCase {
    fileprivate var factory: Factory<UIViewController>!

    override func setUp() {
        super.setUp()
        factory = SessionFactory()
    }

    func testBuild() {
        let view = factory.build()
        XCTAssertTrue(view.description.contains("PopupDialog.PopupDialog"))
    }
}
