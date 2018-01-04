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

private struct OauthProvider: NetworkProvider {
    let credentials: Credentials

    var method: HTTPMethod {
        return .POST
    }
    var uri: String {
        return "/authentication/token"
    }
    var parameters: JSON {
        return [
            "grant_type": "password",
            "password": credentials.password,
            "username": credentials.email
        ]
    }
    var useClientKeys: Bool {
        return true
    }
}

class GetOauth: DataSource<Credentials, Oauth> {
    override func execute(args: Credentials) -> Result<Oauth> {
        let provider = OauthProvider(credentials: args)
        return Network(provider: provider).call(tryRefreshOauth: false)
    }
}
