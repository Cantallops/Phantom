//
//  MockInteractor.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
@testable import Phantom

class MockInteractor<Input, Output>: Interactor<Input, Output> {
    var result: Result<Output>!

    init(result: Result<Output>) {
        self.result = result
        super.init()
    }

    var executeWasCalled: Bool = false
    override func execute(args: Input) -> Result<Output> {
        executeWasCalled = true
        return result
    }
}
