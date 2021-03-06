//
//  BrowseTagsAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct BrowseTagsAPIProvider: NetworkProvider {
    var method: HTTPMethod {
        return .GET
    }

    var uri: String {
        return "/tags/"
    }

    var parameters: JSON {
        return [
            "limit": "all",
            "include": "count.posts"
        ]
    }

    var authenticated: Bool {
        return true
    }
}
