//
//  TestErrors.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct TestError: Error, LocalizedError {
    let localizedDescription: String

    init(localizedDescription: String = "Test error") {
        self.localizedDescription = localizedDescription
    }

    public var errorDescription: String? {
        return self.localizedDescription
    }
}
