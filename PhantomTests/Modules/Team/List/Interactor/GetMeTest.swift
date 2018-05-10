//
//  GetMeTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class GetMeTest: XCTestCase {

    fileprivate var interactor: GetMeInteractor!
    fileprivate var remote: MockDataSource<Any?, TeamMember>!
    fileprivate let teamMember = TeamMember.any

    override func setUp() {
        super.setUp()
        remote = MockDataSource(result: Result.success(teamMember))
        interactor = GetMeInteractor(getMeRemote: remote)
    }

    func testWhenRemoteFailsExecuteShouldFail() {
        remote.result = Result.failure(TestError())
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isFailure)
    }

    func testExecute() {
        remote.result = Result.success(teamMember)
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.value?.id, teamMember.id)
    }

}
