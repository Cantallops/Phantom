//
//  LoaderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 12/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class LoaderTest: XCTestCase {

    func testStartLoaderArray() {
        let loaders: [Loader] = [MockLoader(), MockLoader()]
        check(isLoading: false, forLoaders: loaders)
        loaders.start()
        check(isLoading: true, forLoaders: loaders)
    }

    func testStopLoaderArray() {
        let loaders: [Loader] = [MockLoader(), MockLoader()]
        loaders.start()
        check(isLoading: true, forLoaders: loaders)
        loaders.stop()
        check(isLoading: false, forLoaders: loaders)
    }

    func check(isLoading: Bool, forLoaders loaders: [Loader]) {
        for loader in loaders {
            XCTAssertEqual(loader.isLoading, isLoading)
        }
    }
}
