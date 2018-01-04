//
//  UITestHelper.swift
//  PhantomUITests
//
//  Created by Alberto Cantallops on 01/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest

extension XCUIApplication {
    func tap(button buttonId: String) {
        buttons[buttonId].tap()
    }

    func type(text: String, onField fieldId: String) {
        let tf = textFields[fieldId]
        tf.tap()
        tf.typeText(text)
    }

    func type(text: String, onSecureField fieldId: String) {
        let tf = secureTextFields[fieldId]
        tf.tap()
        tf.typeText(text)
    }
}
