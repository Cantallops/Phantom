//
//  StoryDetailRobot.swift
//  PhantomUITests
//
//  Created by Alberto Cantallops on 01/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest

class StoryDetailRobot {
    @discardableResult
    func focusContent() -> Self {
        let app = XCUIApplication()
        app.textViews["content"].tap()
        return self
    }

    @discardableResult
    func goSettings() -> Self {
        let app = XCUIApplication()
        app.navigationBars.buttons["storySettings"].tap()
        return self
    }

    @discardableResult
    func exit() -> Self {
        let app = XCUIApplication()
        app.toolbars.buttons["Done"].tap()
        return self
    }
}
