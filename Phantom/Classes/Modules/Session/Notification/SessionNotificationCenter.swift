//
//  SessionNotificationCenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 09/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

let sessionNotificationCenter = InternalNotificationCenter<Account?>()
extension InternalNotification {
    static let signOut = InternalNotification(name: "signOut")
    static let signIn = InternalNotification(name: "signIn")
}
