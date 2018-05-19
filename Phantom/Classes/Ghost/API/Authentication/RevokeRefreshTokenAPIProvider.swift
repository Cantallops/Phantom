//
//  RevokeRefreshTokenAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct RevokeRefreshTokenAPIProvider: NetworkProvider {
    let oauth: Oauth

    var method: HTTPMethod {
        return .POST
    }

    var uri: String {
        return "/authentication/revoke"
    }

    var parameters: JSON {
        return [
            "tokenTypeHint": "refresh_token",
            "token": oauth.refreshToken
        ]
    }

    var authenticated: Bool {
        return true
    }
}
