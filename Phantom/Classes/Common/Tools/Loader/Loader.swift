//
//  Loader.swift
//  Phantom
//
//  Created by Alberto Cantallops on 10/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

protocol Loader {
    var isLoading: Bool { get }
    func start()
    func stop()
}

extension Array where Element==Loader {
    func start() {
        for loader in self {
            loader.start()
        }
    }

    func stop() {
        for loader in self {
            loader.stop()
        }
    }
}
