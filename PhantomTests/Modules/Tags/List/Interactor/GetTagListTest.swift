//
//  GetTagListTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class GetTagListTest: XCTestCase {

    fileprivate var interactor: GetTagListInteractor!
    fileprivate var remote: MockDataSource<Meta?, Paginated<[Tag]>>!
    fileprivate let tag = Tag.any

    override func setUp() {
        super.setUp()
        remote = MockDataSource(result: Result.failure(TestError()))
        interactor = GetTagListInteractor(getTagListDataSource: remote)
    }

    func testWhenRemoteFailsExecuteShouldFail() {
        remote.result = Result.failure(TestError())
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isFailure)
    }

    func testExecute() {
        let paginated = Paginated(object: [tag], meta: Meta(pagination: .all))
        remote.result = Result.success(paginated)
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.value?.object.first?.id, tag.id)
    }

}
