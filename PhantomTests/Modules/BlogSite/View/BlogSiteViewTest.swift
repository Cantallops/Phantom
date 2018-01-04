//
//  BlogSiteViewTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 11/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class BlogSiteViewTest: XCTestCase {

    fileprivate var view: BlogSiteView!

    override func setUp() {
        super.setUp()
        view = BlogSiteView(presenter: MockPresenter())
        UIApplication.shared.keyWindow?.rootViewController = view
    }

    func testShouldCallOnTapButtonClosure() {
        let text = "blog.ghost.com"
        var textResult: String?
        view.urlField.text = text
        view.onTapButton = { blogUrl in
            textResult = blogUrl
        }
        view.goButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(textResult, text)
    }

    func testReturnOnTextFieldShouldCallOnTapButton() {
        let text = "blog.ghost.com"
        var textResult: String?
        view.urlField.text = text
        view.onTapButton = { blogUrl in
            textResult = blogUrl
        }
        _ = view.urlField.textFieldShouldReturn(view.urlField)
        XCTAssertEqual(textResult, text)
    }

    func testShowError() {
        let errorText = "Error"
        view.show(error: errorText)
        XCTAssertEqual(view.errorLabel.text, errorText)
    }

    func testClearErrors() {
        let errorText = "Error"
        view.show(error: errorText)
        view.clearError()
        if let errorLabelText = view.errorLabel.text {
            XCTAssertTrue(errorLabelText.isEmpty, "Error label should be empty or nil")
        }
    }

}
