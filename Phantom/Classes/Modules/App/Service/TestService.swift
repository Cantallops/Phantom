//
//  TestService.swift
//  Phantom
//
//  Created by Alberto Cantallops on 08/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TestService: NSObject, UIApplicationDelegate {

        func application(
            _ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil
        ) -> Bool {
            guard
                let delegate = application.delegate,
                let window = delegate.window as? UIWindow
            else {
                    return false
            }
            window.rootViewController = UIViewController()
            window.makeKeyAndVisible()
            return true
        }
}
