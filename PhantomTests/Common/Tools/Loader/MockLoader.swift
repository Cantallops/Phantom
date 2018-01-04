//
//  MockLoader.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 12/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
@testable import Phantom

class MockLoader: Loader {
    var isLoading: Bool

    init() {
        isLoading = false
    }

    func start() {
        isLoading = true
    }

    func stop() {
        isLoading = false
    }
}
