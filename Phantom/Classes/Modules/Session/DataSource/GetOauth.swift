//
//  GetOauth.swift
//  Phantom
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct Oauth: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    let tokenType: String

    var authorization: String {
        return "\(tokenType) \(accessToken)"
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

class GetOauth: DataSource<Credentials, Oauth> {
    override func execute(args: Credentials) -> Result<Oauth> {
        let provider = OauthAPIProvider(credentials: args)
        return Network().call(provider: provider, tryRefreshOauth: false)
    }
}
