//
//  SignInViewTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class SignInViewTest: XCTestCase {

    fileprivate var view: SignInView!

    override func setUp() {
        super.setUp()
        view = SignInView(presenter: MockPresenter())
        UIApplication.shared.keyWindow?.rootViewController = view
    }

    func testShouldCallOnTapButtonClosure() {
        let email = "email"
        let pass = "pass"
        var credentialsResult: SignInView.Credentials?

        view.emailField.text = email
        view.passwordField.text = pass
        view.onTapSignInButton = { credentials in
            credentialsResult = credentials
        }
        view.signInButton.sendActions(for: .touchUpInside)
        XCTAssertEqual(credentialsResult?.email, email)
        XCTAssertEqual(credentialsResult?.password, pass)
    }

    func testReturnOnPasswordFieldShouldCallOnTapButton() {
        let email = "email"
        let pass = "pass"
        var credentialsResult: SignInView.Credentials?

        view.emailField.text = email
        view.passwordField.text = pass
        view.onTapSignInButton = { credentials in
            credentialsResult = credentials
        }
        _ = view.passwordField.textFieldShouldReturn(view.passwordField)
        XCTAssertEqual(credentialsResult?.email, email)
        XCTAssertEqual(credentialsResult?.password, pass)
    }

    func testReturnOnEmailFieldShouldTabToPasswordField() {
        XCTAssertFalse(view.passwordField.isFirstResponder)
        _ = view.emailField.textFieldShouldReturn(view.emailField)
        XCTAssertTrue(view.passwordField.isFirstResponder)
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
