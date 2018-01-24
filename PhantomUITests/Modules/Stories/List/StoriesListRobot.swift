//
//  StoriesListRobot.swift
//  PhantomUITests
//
//  Created by Alberto Cantallops on 01/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest

class StoriesListRobot {

    @discardableResult
    func goToStory(_ bound: Int = 0) -> Self {
        let app = XCUIApplication()
        app.tables["storiesTable"].cells.element(boundBy: bound).tap()
        return self
    }
}
