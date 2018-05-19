//
//  ReadUserAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct ReadUserAPIProvider: NetworkProvider {
    var id: String

    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/users/\(id)/"
    }
    var parameters: JSON {
        return [
            "include": "roles"
        ]
    }
    var authenticated: Bool {
        return true
    }
}
