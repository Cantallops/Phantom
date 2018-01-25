//
//  EditTagInteractorTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class EditTagInteractorTest: XCTestCase {

    fileprivate var interactor: EditTagInteractor!
    fileprivate var remote: MockDataSource<Tag, Tag>!
    fileprivate let tag = Tag.any

    override func setUp() {
        super.setUp()
        remote = MockDataSource(result: Result.failure(TestError()))
        interactor = EditTagInteractor(editTagRemote: remote)
    }

    func testWhenRemoteFailsExecuteShouldFail() {
        remote.result = Result.failure(TestError())
        let result = interactor.execute(args: tag)
        XCTAssertTrue(result.isFailure)
    }

    func testExecute() {
        remote.result = Result.success(tag)
        let result = interactor.execute(args: tag)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.value?.id, tag.id)
    }

}
