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

    fileprivate var interactor: FilterStoriesInteractor!
    fileprivate var stories = [
        Story.any.setting(title: "Title").setting(tags: [Tag.any.setting(id: "tagID1")]),
        Story.any.setting(title: "A second title").setting(tags: [Tag.any.setting(id: "tagID2")]),
        Story.any.setting(title: "A third story").setting(tags: [Tag.any.setting(id: "tagID2")])
    ]

    override func setUp() {
        super.setUp()
        interactor = FilterStoriesInteractor()
    }

    func testFilterByTextWithResults() {
        let filter = StoryFilters(tagID: nil, text: "Title")
        let result = interactor.execute(args: (stories, filter))
        XCTAssertEqual(result.value!.count, 2)
    }

    func testFilterByTestWithoutResults() {
        let filter = StoryFilters(tagID: nil, text: "stories")
        let result = interactor.execute(args: (stories, filter))
        XCTAssertTrue(result.value!.isEmpty)
    }

    func testFilterByTagWithResults() {
        let filter = StoryFilters(tagID: "tagID2", text: "")
        let result = interactor.execute(args: (stories, filter))
        XCTAssertEqual(result.value!.count, 2)
    }

    func testFilterByTagWithoutResults() {
        let filter = StoryFilters(tagID: "tagID3", text: "")
        let result = interactor.execute(args: (stories, filter))
        XCTAssertTrue(result.value!.isEmpty)
    }
}
