//
//  MockBuilder.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
@testable import Phantom

class MockBuilder<Input, Output>: Builder<Input, Output> {
    var result: Output

    init(result: Output) {
        self.result = result
        super.init()
    }

    var buildWasCalled: Bool = false
    var buildInput: Input?
    override func build(arg: Input) -> Output {
        buildWasCalled = true
        buildInput = arg
        return result
    }
}
