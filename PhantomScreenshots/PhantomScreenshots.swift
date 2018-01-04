//
//  PhantomScreenshots.swift
//  PhantomScreenshots
//
//  Created by Alberto Cantallops on 31/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest

class PhantomScreenshots: XCTestCase {

    override func setUp() {
        super.setUp()
        let app = XCUIApplication()
        app.launchEnvironment = ["SIMULATOR_STATUS_MAGIC_OVERRIDES": "enable"]
        setupSnapshot(app)
        app.launch()
    }

    func testScreenshot() {
        BlogSiteRobot()
            .typeBlogUrl()
            .checkGhostBlog()
        SignInRobot()
            .typeEmail()
            .typePassword()
            .signIn()

        snapshot("1Posts")
        StoriesListRobot().goToStory()
        snapshot("2Post")
        let storyRobot = StoryDetailRobot()
            .focusContent()
        snapshot("3FocusPost")
        storyRobot.goSettings()
        snapshot("4PostSettings")
    }

}
