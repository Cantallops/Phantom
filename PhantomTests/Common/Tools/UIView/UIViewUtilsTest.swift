//
//  UIViewUtilsTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 12/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest

class UIViewUtilsTest: XCTestCase {

    private var viewController: UIViewController!

    override func setUp() {
        super.setUp()
        viewController = UIViewController()
        set(rootViewController: viewController)
    }

    func testFindFirstResponder() {
        let secondView = UIView()
        let field = UITextView()
        secondView.addSubview(field)
        viewController.view.addSubview(secondView)
        field.becomeFirstResponder()
        XCTAssertEqual(viewController.view.findFirstResponder(), field)
        XCTAssertNil(viewController.view.findFirstResponder(maxDeep: 0))
    }

    func testFindFirstResponderNil() {
        let secondView = UIView()
        let field = UITextView()
        secondView.addSubview(field)
        viewController.view.addSubview(secondView)
        XCTAssertNil(viewController.view.findFirstResponder())
    }

    func testFindScrollView() {
        let secondView = UIView()
        let scrollView = UIScrollView()
        secondView.addSubview(scrollView)
        viewController.view.addSubview(secondView)
        XCTAssertEqual(viewController.view.findScrollView(), scrollView)
        XCTAssertNil(viewController.view.findScrollView(maxDeep: 0))
    }

    func testFindScrollViewResponderNil() {
        let secondView = UIView()
        viewController.view.addSubview(secondView)
        XCTAssertNil(viewController.view.findScrollView())
    }
}
