//
//  BrowseUsersAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct BrowseUsersAPIProvider: NetworkProvider {
    var method: HTTPMethod {
        return .GET
    }

    var uri: String {
        return "/users/"
    }

    var parameters: JSON {
        return [
            "include": "roles",
            "limit": "all"
        ]
    }

    var authenticated: Bool {
        return true
    }
}
