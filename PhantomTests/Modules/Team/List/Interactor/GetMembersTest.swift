//
//  GetMembersTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class GetMembersTest: XCTestCase {

    fileprivate var interactor: GetMembers!
    fileprivate var remote: MockDataSource<Meta?, Paginated<[TeamMember]>>!
    fileprivate let teamMember = TeamMember.any

    override func setUp() {
        super.setUp()
        remote = MockDataSource(result: Result.failure(TestError()))
        interactor = GetMembers(getMembersRemote: remote)
    }

    func testWhenRemoteFailsExecuteShouldFail() {
        remote.result = Result.failure(TestError())
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isFailure)
    }

    func testExecute() {
        let paginated = Paginated(object: [teamMember], meta: Meta(pagination: .all))
        remote.result = Result.success(paginated)
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.value?.object.first?.id, teamMember.id)
    }

}
