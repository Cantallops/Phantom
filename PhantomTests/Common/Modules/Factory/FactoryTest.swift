//
//  FactoryTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class FactoryTest: XCTestCase {
    func testFatalErrorBuild() {
        let factory = Factory<Any?>()
        expectFatalError(expectedMessage: "You should implement in a subclass") {
            _ = factory.build()
        }
    }
}

public func XCTAssertViewFactory(
    _ factory: Factory<UIViewController>,
    expectedViewClass: AnyClass,
    expectedPresenterClass: AnyClass,
    file: StaticString = #file,
    line: UInt = #line
) {
    let view = factory.build()
    XCTAssertTrue(
        view.isKind(of: expectedViewClass),
        "Should return an instance of \(expectedViewClass.description())",
        file: file,
        line: line
    )
    guard let viewController = view as? Presentable else {
        XCTFail(
            "View should be a ViewController",
            file: file,
            line: line
        )
        return
    }
    XCTAssertTrue(
        type(of: viewController.presenter) == expectedPresenterClass,
        "Presenter should be an instance of \(expectedPresenterClass.description())",
        file: file,
        line: line
    )
}
