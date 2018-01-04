//
//  DataSource.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class DataSource<Input, Output> {
    func execute(args: Input) -> Result<Output> {
        let error = NotImplementedError()
        return Result.failure(error)
    }
}
