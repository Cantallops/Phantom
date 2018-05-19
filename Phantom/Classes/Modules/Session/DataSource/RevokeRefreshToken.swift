//
//  RevokeRefreshToken.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct RevokedRefreshToken: Codable {
    let token: String
}

class RevokeRefreshToken: DataSource<Oauth, Any?> {
    override func execute(args: Oauth) -> Result<Any?> {
        let provider = RevokeRefreshTokenAPIProvider(oauth: args)
        let result: Result<RevokedRefreshToken> = Network().call(provider: provider, tryRefreshOauth: false)
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
