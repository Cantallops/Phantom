//
//  AppDelegateTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 05/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class AppDelegateTest: XCTestCase {

    // swiftlint:disable:next weak_delegate
    fileprivate var appDelegate: AppDelegate!
    fileprivate var firstFakeService: FakeAppDelegateService!
    fileprivate var secondFakeService: FakeAppDelegateService!

    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
        appDelegate.checkRunningTest = false
        firstFakeService = FakeAppDelegateService()
        secondFakeService = FakeAppDelegateService()
        appDelegate.services = [firstFakeService, secondFakeService]
    }

    override func tearDown() {
        super.tearDown()
    }

    func testExecuteDidFinishLaunchingShouldExecuteAllOfServices() {
        _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(firstFakeService.executedDidFinishLaunchingWithOptions)
        XCTAssertTrue(secondFakeService.executedDidFinishLaunchingWithOptions)
    }

    func testExecuteDidFinishLaunchingShouldReturnFalseIfOneOfTheServicesDoes() {
        secondFakeService.didFinishLaunchingWithOptionsResult = false

        let result = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(firstFakeService.executedDidFinishLaunchingWithOptions)
        XCTAssertTrue(secondFakeService.executedDidFinishLaunchingWithOptions)
        XCTAssertFalse(result)
    }

    func testExecuteDidFinishLaunchingShouldNotExecuteFollowingServiceIfOneReturnFalse() {
        secondFakeService.didFinishLaunchingWithOptionsResult = false
        let thirdFakeService = FakeAppDelegateService()

        appDelegate.services = [firstFakeService, secondFakeService, thirdFakeService]
        _ = appDelegate.application(UIApplication.shared, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(firstFakeService.executedDidFinishLaunchingWithOptions)
        XCTAssertTrue(secondFakeService.executedDidFinishLaunchingWithOptions)
        XCTAssertFalse(thirdFakeService.executedDidFinishLaunchingWithOptions)
    }
}

private class FakeAppDelegateService: NSObject, UIApplicationDelegate {

    var executedDidFinishLaunchingWithOptions: Bool = false
    var didFinishLaunchingWithOptionsResult: Bool = true

    override init() {
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil
    ) -> Bool {
        executedDidFinishLaunchingWithOptions = true
        return didFinishLaunchingWithOptionsResult
    }
}
