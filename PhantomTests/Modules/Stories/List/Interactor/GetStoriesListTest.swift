//
//  GetStoriesListTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class GetStoriesListTest: XCTestCase {

    fileprivate var interactor: GetStoriesList!
    fileprivate var remote: MockDataSource<Meta?, Paginated<[Story]>>!
    fileprivate let story = Story.any

    override func setUp() {
        super.setUp()
        remote = MockDataSource(result: Result.failure(TestError()))
        interactor = GetStoriesList(getStoriesListDataSource: remote)
    }

    func testWhenRemoteFailsExecuteShouldFail() {
        remote.result = Result.failure(TestError())
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isFailure)
    }

    func testExecute() {
        let paginated = Paginated(object: [story], meta: Meta(pagination: .all))
        remote.result = Result.success(paginated)
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.value?.object.first?.id, story.id)
    }

}
