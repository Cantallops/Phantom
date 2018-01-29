//
//  GetSubscribersTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class GetSubscribersTest: XCTestCase {

    fileprivate var interactor: GetSubscribers!
    fileprivate var remote: MockDataSource<Meta?, Paginated<[Subscriber]>>!
    fileprivate let subscriber = Subscriber.any

    override func setUp() {
        super.setUp()
        remote = MockDataSource(result: Result.failure(TestError()))
        interactor = GetSubscribers(getSubscribersDataSource: remote)
    }

    func testWhenRemoteFailsExecuteShouldFail() {
        remote.result = Result.failure(TestError())
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isFailure)
    }

    func testExecute() {
        let paginated = Paginated(object: [subscriber], meta: Meta(pagination: .all))
        remote.result = Result.success(paginated)
        let result = interactor.execute(args: nil)
        XCTAssertTrue(result.isSuccess)
        XCTAssertEqual(result.value?.object.first?.id, subscriber.id)
    }

}
