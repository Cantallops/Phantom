//
//  GeneralSettingsFactoryTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 28/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class GeneralSettingsBuilderTest: XCTestCase {
    fileprivate var builder: Builder<Account, UIViewController>!

    override func setUp() {
        super.setUp()
        builder = GeneralSettingsBuilder()
    }

    func testBuild() {
    }
}
