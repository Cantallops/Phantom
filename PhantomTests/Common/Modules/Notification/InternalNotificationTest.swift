//
//  InternalNotificationTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class InternalNotificationTest: XCTestCase {

    var internalNotificationCenter: InternalNotificationCenter<String>!
    let notification = InternalNotification(name: "TestInternalNotification")
    private var notificationCenter: NotificationCenterMock!

    override func setUp() {
        super.setUp()
        notificationCenter = NotificationCenterMock()
        internalNotificationCenter = InternalNotificationCenter(notificationCenter: notificationCenter)
    }

    func testAddObserver() {
        XCTAssertNil(notificationCenter.lastObjectObserver)
        let observer = internalNotificationCenter.addObserver(forType: notification) { _ in
        }
        XCTAssertTrue(observer.isEqual(notificationCenter.lastObjectObserver), "Add observer does not work")
    }

    func testRemoveObserver() {
        XCTAssertNil(notificationCenter.lastObjectObserver)
        let observer = internalNotificationCenter.addObserver(forType: notification) { _ in
        }
        internalNotificationCenter.remove(observer: observer)
        XCTAssertTrue(observer.isEqual(notificationCenter.lastObjectObserverRemoved), "Add observer does not work")
    }

    func testPostNotification() {
        let expectation = self.expectation(description: "expectingPost")
        let postedString = "Hi I am a internal notification"
        let observer = internalNotificationCenter.addObserver(forType: notification) { receivedString in
            XCTAssertEqual(receivedString, postedString)
            expectation.fulfill()
        }
        internalNotificationCenter.post(notification, object: postedString)
        internalNotificationCenter.remove(observer: observer)
        wait(for: [expectation], timeout: 1)
    }
}

private class NotificationCenterMock: NotificationCenter {

    var lastObjectObserver: NSObjectProtocol?
    override func addObserver(
        forName name: NSNotification.Name?,
        object obj: Any?,
        queue: OperationQueue?,
        using block: @escaping (Notification) -> Void
    ) -> NSObjectProtocol {
        let object = super.addObserver(forName: name, object: obj, queue: queue, using: block)
        lastObjectObserver = object
        return object
    }

    var lastObjectObserverRemoved: NSObjectProtocol?
    override func removeObserver(_ observer: Any) {
        super.removeObserver(observer)
        lastObjectObserverRemoved = observer as? NSObjectProtocol
    }
}
