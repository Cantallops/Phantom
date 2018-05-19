//
//  SubscribersAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct SubscribersAPIProvider: NetworkProvider {
    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/subscribers/"
    }
    var parameters: JSON {
        let params: JSON = [
            "limit": "all"
        ]
        return params
    }
    var authenticated: Bool {
        return true
    }
}
