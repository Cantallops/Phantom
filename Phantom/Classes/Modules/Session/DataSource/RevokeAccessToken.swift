//
//  RevokeOauth.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct RevokeAccessTokenProvider: NetworkProvider {
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

struct RevokedAccessToken: Codable {
    let token: String
}

class RevokeAccessToken: DataSource<Oauth, Any?> {
    override func execute(args: Oauth) -> Result<Any?> {
        let provider = RevokeAccessTokenProvider(oauth: args)
        let result: Result<RevokedAccessToken> = Network(provider: provider).call(tryRefreshOauth: false)
        switch result {
        case .success(let revokedOauth):
            if revokedOauth.token != args.accessToken {
                let error = NetworkError(kind: .parse, debugDescription: "Tokens does not match")
                return .failure(error)
            }
            return .success(nil)
        case .failure(let error):
            return .failure(error)
        }
    }
}
