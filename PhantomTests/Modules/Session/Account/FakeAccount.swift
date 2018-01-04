//
//  FakeAccount.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
@testable import Phantom

extension Account {
    static let logged = Account(
        blogUrl: "loggedBlogUrl",
        apiVersion: "loggedApiVersion",
        username: "loggedUsername",
        clientKeys: ClientKeys(secret: "secret", id: "id"),
        oauth: Oauth(accessToken: "", refreshToken: "", expiresIn: 0, tokenType: "")
    )

    static let signedout = Account(
        blogUrl: "notloggedBlogUrl",
        apiVersion: "notloggedApiVersion",
        username: "notloggedUsername",
        clientKeys: nil,
        oauth: nil
    )
}
