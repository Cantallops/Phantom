//
//  DoSignOutInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class DoSignOutInteractor: Interactor<Any?, Any?> {

    let revokeAccessToken: DataSource<Oauth, Any?>
    let revokeRefreshToken: DataSource<Oauth, Any?>

    init(
        revokeAccessToken: DataSource<Oauth, Any?> = RevokeAccessToken(),
        revokeRefreshToken: DataSource<Oauth, Any?> = RevokeRefreshToken()
    ) {
        self.revokeAccessToken = revokeAccessToken
        self.revokeRefreshToken = revokeRefreshToken
        super.init()
    }

    override func execute(args: Any?) -> Result<Any?> {
        var result: Result<Any?> = .success(nil)

        if var account = Account.current {
            if let oauth = account.oauth {
                let revokedRefreshTokenResult = revokeRefreshToken.execute(args: oauth)
                let revokedAccessTokenResult = revokeAccessToken.execute(args: oauth)
                let combinedResult = revokedAccessTokenResult.combined(result: revokedRefreshTokenResult)
                switch combinedResult {
                case .failure(let error): result = .failure(error)
                case .success: result = .success(nil)
                }
            }
            account.signOut()
        }

        let account = Account.current
        DispatchQueue.main.async {
            sessionNotificationCenter.post(.signOut, object: account)
        }
        Account.current = nil

        return result
    }
}
