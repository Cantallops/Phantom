//
//  OauthAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct OauthAPIProvider: NetworkProvider {
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
