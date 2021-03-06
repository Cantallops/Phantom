//
//  ReadPostAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct ReadPostAPIProvider: NetworkProvider {
    let id: String

    var method: HTTPMethod {
        return .GET
    }

    var uri: String {
        return "/posts/\(id)/"
    }

    var queryParameters: JSON {
        return [
            "include": "author,authors,tags",
            "status": "all",
            "formats": "mobiledoc,html"
        ]
    }

    var authenticated: Bool {
        return true
    }

    var contentType: ContentType {
        return .json
    }
}
