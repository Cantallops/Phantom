//
//  InitialModuleServiceTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 11/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class InitialModuleServiceTest: XCTestCase {

    fileprivate var service: UIApplicationDelegate!
    fileprivate var application: UIApplication!
    // swiftlint:disable:next weak_delegate
    fileprivate weak var delegate: AppDelegate!

    private let dashboard = UIViewController()
    private let sessionView = UIViewController()

    override func setUp() {
        super.setUp()
        service = InitialModuleService(
            sessionFactory: MockFactory<UIViewController>(result: sessionView),
            dashboardFactory: MockFactory<UIViewController>(result: dashboard)
        )
        application = UIApplication.shared
        self.delegate = (application.delegate as? AppDelegate)!
    }

    override func tearDown() {
        Account.current = nil
        Account.last = nil
        super.tearDown()
    }

    func testShouldReturnFalseIfThereIsNoWindow() {
        delegate.window = nil
        let result = service.application!(application, didFinishLaunchingWithOptions: [:])
        XCTAssertFalse(result, "If there are no window should return false")
    }

    func testShouldInitializeNavigationViewLogged() {
        Account.current = .logged
        expectation(
            forNotification: NSNotification.Name(rawValue: InternalNotification.signIn.name),
            object: nil,
            handler: nil
        )
        let result = service.application!(application, didFinishLaunchingWithOptions: [:])
        XCTAssertTrue(result)
        waitForExpectations(timeout: 2, handler: nil)
        guard let viewController = getRootViewController() else {
            XCTFail("Root view controller should be initialized")
            return
        }
        XCTAssertTrue(viewController == dashboard, "The initial view should be Dashboard instance")
        XCTAssertNil(viewController.presentedViewController)
    }

    func testShouldInitializeNavigationViewWithBlogSiteAsRoot() {
        let result = service.application!(application, didFinishLaunchingWithOptions: [:])
        XCTAssertTrue(result, "Should return true")
        let viewController = getRootViewController()!
        XCTAssertTrue(viewController == dashboard, "The initial view should be Dashboard instance")
        XCTAssertTrue(viewController.presentedViewController == sessionView)
    }

    func getRootViewController() -> UIViewController? {
        let window = delegate.window!
        return window.rootViewController
    }
}
