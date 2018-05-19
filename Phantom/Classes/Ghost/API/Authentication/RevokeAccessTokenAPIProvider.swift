//
//  RevokeAccessTokenAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct RevokeAccessTokenAPIProvider: NetworkProvider {
    let oauth: Oauth

    var method: HTTPMethod {
        return .POST
    }

    var uri: String {
        return "/authentication/revoke"
    }

    var parameters: JSON {
        return [
            "tokenTypeHint": "access_token",
            "token": oauth.accessToken
        ]
    }

    var useClientKeys: Bool {
        return true
    }

    var authenticated: Bool {
        return true
    }
}
