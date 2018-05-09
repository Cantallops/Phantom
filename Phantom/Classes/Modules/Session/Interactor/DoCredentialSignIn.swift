//
//  DoCredentialSignIn.swift
//  Phantom
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct Credentials {
    let email: String
    let password: String
}

class DoCredentialSignIn: Interactor<Credentials, Any?> {

    fileprivate let getOauth: DataSource<Credentials, Oauth>

    init(getOauth: DataSource<Credentials, Oauth> = GetOauth()) {
        self.getOauth = getOauth
        super.init()
    }

    override func execute(args: Credentials) -> Result<Any?> {
        let oauthResult = getOauth.execute(args: args)
        switch oauthResult {
        case .success(let oauth):
            let account = Account(
                blogUrl: Account.current!.blogUrl,
                apiVersion: Account.current!.apiVersion,
                username: args.email,
                clientKeys: Account.current!.clientKeys,
                oauth: oauth
            )
            Account.current = account
            DispatchQueue.main.async {
                sessionNotificationCenter.post(.signIn, object: account)
            }
            return .success(nil)
        case .failure(let error):
            return .failure(error)
        }
    }
}
