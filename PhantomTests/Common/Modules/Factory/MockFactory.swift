//
//  MockFactory.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 26/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
@testable import Phantom

class MockFactory<Output>: Factory<Output> {
    var result: Output

    init(result: Output) {
        self.result = result
        super.init()
    }

    var executeWasCalled: Bool = false
    override func build() -> Output {
        executeWasCalled = true
        return result
    }
}
