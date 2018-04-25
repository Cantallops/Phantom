//
//  FilterStoriesTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/04/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class FilterStoriesTest: XCTestCase {

    fileprivate var interactor: FilterStories!

    override func setUp() {
        super.setUp()
        interactor = FilterStories()
    }

    func testFilterWithResults() {
        let stories: [Story] = [
            Story.any.settingTitle(title: "Title"),
            Story.any.settingTitle(title: "A second title"),
            Story.any.settingTitle(title: "A third story")
        ]
        let result = interactor.execute(args: (stories, "Title"))
        XCTAssertEqual(result.value!.count, 2)
    }

    func testFilterWithoutResults() {
        let stories: [Story] = [
            Story.any.settingTitle(title: "Title"),
            Story.any.settingTitle(title: "A second title"),
            Story.any.settingTitle(title: "A third story")
        ]
        let result = interactor.execute(args: (stories, "stories"))
        XCTAssertTrue(result.value!.isEmpty)
    }
}
