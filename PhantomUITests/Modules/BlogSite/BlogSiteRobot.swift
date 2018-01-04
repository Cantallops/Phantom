//
//  BlogSiteRobot.swift
//  PhantomUITests
//
//  Created by Alberto Cantallops on 01/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest

class BlogSiteRobot {

    @discardableResult
    func typeBlogUrl(_ url: String = "localhost:2368") -> Self {
        let app = XCUIApplication()
        app.type(text: url, onField: "blogSiteUrl")
        return self
    }

    @discardableResult
    func checkGhostBlog() -> Self {
        let app = XCUIApplication()
        app.tap(button: "goBlogSite")
        return self
    }
}
