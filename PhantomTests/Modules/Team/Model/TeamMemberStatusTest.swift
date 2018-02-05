//
//  TeamMemberStatusTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 05/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class TeamMemberStatusTest: XCTestCase {

    func testActiveisAnActiveStatus() {
        let status = TeamMember.Status.active
        XCTAssertTrue(status.isActiveStatus())
        XCTAssertFalse(status.isInactiveStatus())
    }

    func testLockedisAnActiveStatus() {
        let status = TeamMember.Status.locked
        XCTAssertTrue(status.isActiveStatus())
        XCTAssertFalse(status.isInactiveStatus())
    }

    func testWarn1isAnActiveStatus() {
        let status = TeamMember.Status.warn1
        XCTAssertTrue(status.isActiveStatus())
        XCTAssertFalse(status.isInactiveStatus())
    }

    func testWarn2isAnActiveStatus() {
        let status = TeamMember.Status.warn2
        XCTAssertTrue(status.isActiveStatus())
        XCTAssertFalse(status.isInactiveStatus())
    }

    func testWarn3isAnActiveStatus() {
        let status = TeamMember.Status.warn3
        XCTAssertTrue(status.isActiveStatus())
        XCTAssertFalse(status.isInactiveStatus())
    }

    func testWarn4isAnActiveStatus() {
        let status = TeamMember.Status.warn4
        XCTAssertTrue(status.isActiveStatus())
        XCTAssertFalse(status.isInactiveStatus())
    }

    func testInactiveIsAnInactiveStatus() {
        let status = TeamMember.Status.inactive
        XCTAssertTrue(status.isInactiveStatus())
        XCTAssertFalse(status.isActiveStatus())
    }

}
