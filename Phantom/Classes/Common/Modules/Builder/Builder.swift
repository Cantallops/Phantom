//
//  Builder.swift
//  Phantom
//
//  Created by Alberto Cantallops on 28/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class Builder<Input, Output> {
    func build(arg: Input) -> Output {
        fatalError("You should implement in a subclass")
    }
}
