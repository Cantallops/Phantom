//
//  CreateStoryInteractorTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class CreateStoryInteractorTest: XCTestCase {

    fileprivate var interactor: CreateStoryInteractor!
    fileprivate var remote: MockDataSource<Story, Story>!
    fileprivate let story = Story.any

    override func setUp() {
        super.setUp()
        remote = MockDataSource(result: Result.failure(TestError()))
        interactor = CreateStoryInteractor(createRemote: remote)
    }

    func testWhenRemoteFailsExecuteShouldFail() {
        remote.result = Result.failure(TestError())
        let result = interactor.execute(args: story)
        XCTAssertTrue(result.isFailure)
    }

    func testExecute() {
        remote.result = Result.success(story)
        let result = interactor.execute(args: story)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.value?.id, story.id)
    }

}
