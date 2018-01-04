//
//  DoSignOut.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

let signOutNotification = Notification(name: Notification.Name(rawValue: "signOut"))

class DoSignOut: Interactor<Any?, Any?> {

    let revokeOauth: DataSource<Oauth, Any?>

    init(
        revokeOauth: DataSource<Oauth, Any?> = RevokeOauth()
    ) {
        self.revokeOauth = revokeOauth
        super.init()
    }

    override func execute(args: Any?) -> Result<Any?> {
        var result: Result<Any?> = .success(nil)

        if var account = Account.current {
            if let oauth = account.oauth {
                result = revokeOauth.execute(args: oauth)
            }
            account.signOut()
        }

        Account.current = nil

        DispatchQueue.main.async {
            NotificationCenter.default.post(signOutNotification)
        }

        return result
    }
}
