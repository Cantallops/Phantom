//
//  Factory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class Factory<Output> {
    func build() -> Output {
        fatalError("You should implement in a subclass")
    }
}
