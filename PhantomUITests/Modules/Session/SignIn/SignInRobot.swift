//
//  SignInRobot.swift
//  PhantomUITests
//
//  Created by Alberto Cantallops on 01/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest

class SignInRobot {

    @discardableResult
    func typeEmail(_ email: String = "alberto.cantallops@gmail.com") -> Self {
        let app = XCUIApplication()
        app.type(text: email, onField: "email")
        return self
    }

    @discardableResult
    func typePassword(_ pass: String = "qazwsxedcr") -> Self {
        let app = XCUIApplication()
        app.type(text: pass, onSecureField: "password")
        return self
    }

    @discardableResult
    func signIn() -> Self {
        let app = XCUIApplication()
        app.tap(button: "signin")
        return self
    }
}
