//
//  ViewControllerTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 11/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class ViewControllerTest: XCTestCase {

    fileprivate var view: ViewController!
    fileprivate var mockPresenter: MockPresenter!

    override func setUp() {
        super.setUp()
        mockPresenter = MockPresenter()
        view = ViewController(presenter: mockPresenter)
        set(rootViewController: view)
    }

    func testInitCoderShouldFail() {
        let message = "init(coder:) has not been implemented. You must use init(presenter:) instead"
        expectFatalError(expectedMessage: message) {
            _ = ViewController(coder: NSCoder())
        }
    }

    func testViewShouldCallDidLoadWhenViewDidLoad() {
        XCTAssertTrue(mockPresenter.didLoadHasBeenCalled)
    }

    func testPresentViewController() {
        XCTAssertNil(view.presentedViewController, "Should not present anything")
        let viewControllerToPresent = UIViewController()
        view.present(viewControllerToPresent, animated: false)
        XCTAssertEqual(view.presentedViewController, viewControllerToPresent)
    }

    func testPresentViewControllerShoulPresentOnTopOfNavController() {
        let nav = UINavigationController()
        set(rootViewController: nav)
        nav.viewControllers = [view]
        XCTAssertNil(nav.presentedViewController, "Nav should not present anything")
        XCTAssertNil(view.presentedViewController, "View should not present anything")
        let viewControllerToPresent = UIViewController()
        view.present(viewControllerToPresent, animated: false)
        XCTAssertEqual(nav.presentedViewController, viewControllerToPresent)
    }
}
