//
//  Theme.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct Theme: Codable {
    let name: String
    let active: Bool
    let templates: [Template]?
}

extension Theme {
    struct Template: Codable, Equatable {
        let name: String
        let filename: String
    }
}
