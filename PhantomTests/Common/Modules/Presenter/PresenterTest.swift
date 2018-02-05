//
//  PresenterTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 05/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class PresenterTest: XCTestCase {

    fileprivate var presenter: Presenter<UIViewController>!
    fileprivate var viewController: UIViewController!

    override func setUp() {
        super.setUp()
        presenter = Presenter()
        viewController = UIViewController()
        presenter.view = viewController
        set(rootViewController: presenter.view)
        presenter.didLayoutSubviews()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDidLoad() {
        presenter.didLoad()
    }

    func testWillAppear() {
        presenter.willAppear()
    }

    func testDidAppear() {
        presenter.didAppear()
    }

    func testWillDisappear() {
        presenter.willDisappear()
    }

    func testDidDisappear() {
        presenter.didDisappear()
    }

    func testShowError() {
        XCTAssertNil(viewController.presentedViewController, "Should not present anything")
        let error = NetworkError(kind: .unknown, localizedDescription: "Text to show in error")
        presenter.show(error: error)
        let alert = (viewController.presentedViewController as? UIAlertController)!
        XCTAssertEqual(alert.title, "Something was wrong")
        XCTAssertEqual(alert.message, error.localizedDescription)
        XCTAssertEqual(alert.actions.count, 1)
        XCTAssertEqual(alert.actions.first?.title, "Ok")
    }

    func testUnauthorizedError() {
        XCTAssertNil(viewController.presentedViewController, "Should not present anything")
        let error = NetworkError(kind: .unauthorized)
        expectation(forNotification: signOutNotification.name, object: nil, handler: nil)
        presenter.show(error: error)
        waitForExpectations(timeout: 2, handler: nil)
    }

    func testLoader() {
        XCTAssertFalse(presenter.isLoading)
        presenter.start()
        XCTAssertTrue(presenter.isLoading)
        presenter.stop()
        XCTAssertFalse(presenter.isLoading)
    }
}
