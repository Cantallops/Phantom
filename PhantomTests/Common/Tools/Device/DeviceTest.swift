//
//  DeviceTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class DeviceTest: XCTestCase {

    func testIsPad() {
        XCTAssertTrue(PadDeviceMock().isPad)
    }

    func testIsPhone() {
        XCTAssertTrue(PhoneDeviceMock().isPhone)
    }

}

class PadDeviceMock: UIDevice {
    override var userInterfaceIdiom: UIUserInterfaceIdiom {
        return .pad
    }
}

class PhoneDeviceMock: UIDevice {
    override var userInterfaceIdiom: UIUserInterfaceIdiom {
        return .phone
    }
}
