//
//  Interactor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class Interactor<Input, Output> {
    func execute(args: Input) -> Result<Output> {
        let error = NotImplementedError()
        return Result.failure(error)
    }
}
