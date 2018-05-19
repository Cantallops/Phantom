//
//  OauthRefreshAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct OauthRefreshAPIProvider: NetworkProvider {
    let oauth: Oauth

    var method: HTTPMethod {
        return .POST
    }

    var uri: String {
        return "/authentication/token"
    }

    var parameters: JSON {
        return [
            "grant_type": "refresh_token",
            "refresh_token": oauth.refreshToken
        ]
    }

    var useClientKeys: Bool {
        return true
    }
}
