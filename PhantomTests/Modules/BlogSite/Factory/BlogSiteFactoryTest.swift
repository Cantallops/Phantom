//
//  BlogSiteFactoryTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 26/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class BlogSiteFactoryTest: XCTestCase {

    fileprivate var factory: Factory<UIViewController>!

    override func setUp() {
        super.setUp()
        factory = BlogSiteFactory()
    }

    func testBuild() {
        XCTAssertViewFactory(
            factory,
            expectedViewClass: BlogSiteView.self,
            expectedPresenterClass: BlogSitePresenter.self
        )
    }

}
