//
//  LoadStateService.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class LoadStateService: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Account.load()
        return true
    }
}
