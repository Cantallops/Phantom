//
//  RefreshOauth.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct RefreshedOauth: Codable {
    let accessToken: String
    let expiresIn: Int
    let tokenType: String

    func getOauth(fromOauth oauth: Oauth) -> Oauth {
        return Oauth(
            accessToken: accessToken,
            refreshToken: oauth.refreshToken,
            expiresIn: expiresIn,
            tokenType: tokenType
        )
    }

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
    }
}

class RefreshOauth: DataSource<Oauth, Oauth> {
    override func execute(args: Oauth) -> Result<Oauth> {
        let provider = OauthRefreshAPIProvider(oauth: args)
        let result: Result<RefreshedOauth> = Network().call(provider: provider, tryRefreshOauth: false)
        switch result {
        case .success(let refreshedOauth):
            return .success(refreshedOauth.getOauth(fromOauth: args))
        case .failure(let error):
            return .failure(error)
        }
    }
}
