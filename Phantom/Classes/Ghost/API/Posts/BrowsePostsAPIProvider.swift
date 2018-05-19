//
//  BrowsePostsAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct BrowsePostsAPIProvider: NetworkProvider {
    var authorToFilter: String?

    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/posts/"
    }
    var parameters: JSON {
        var params: JSON = [
            "limit": "all",
            "status": "all",
            "include": "author,tags",
            "staticPages": "all",
            "formats": "mobiledoc,html,plaintext"
        ]
        if let authorToFilter = authorToFilter {
            params["filter"] = "author:\(authorToFilter)"
        }
        return params
    }
    var authenticated: Bool {
        return true
    }
}
