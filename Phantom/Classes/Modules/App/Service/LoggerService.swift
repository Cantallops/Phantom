//
//  LoggerService.swift
//  Phantom
//
//  Created by Alberto Cantallops on 14/06/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class LoggerService: NSObject, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil
        ) -> Bool {
        Logger.enable()
        return true
    }
}
