//
//  Worker.swift
//  Phantom
//
//  Created by Alberto Cantallops on 15/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

class Worker {
    func execute<R>(task: Task<R>) {
        fatalError("You should implement in a subclass")
    }
}

struct Task<R> {
    let loaders: [Loader]?
    let task: () -> R
    let completion: ((_ result: R) -> Void)?

    init(
        loaders: [Loader]? = nil,
        task: @escaping () -> R,
        completion: ((_ result: R) -> Void)? = nil
    ) {
        self.loaders = loaders
        self.task = task
        self.completion = completion
    }
}
