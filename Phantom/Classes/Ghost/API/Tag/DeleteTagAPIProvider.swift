//
//  DeleteTagAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct DeleteTagAPIProvider: NetworkProvider {
    let tag: Tag

    var method: HTTPMethod {
        return .DELETE
    }

    var uri: String {
        return "/tags/\(tag.id)/"
    }

    var authenticated: Bool {
        return true
    }
}
