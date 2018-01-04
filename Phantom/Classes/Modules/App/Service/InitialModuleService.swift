//
//  InitialModuleService.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class InitialModuleService: NSObject, UIApplicationDelegate {

    private let sessionFactory: Factory<UIViewController>
    private let dashboardFactory: Factory<UIViewController>

    init(
        sessionFactory: Factory<UIViewController> = SessionFactory(),
        dashboardFactory: Factory<UIViewController> = DashboardFactory()
    ) {
        self.sessionFactory = sessionFactory
        self.dashboardFactory = dashboardFactory
    }

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

        let dashboard = dashboardFactory.build()
        window.rootViewController = dashboard
        window.makeKeyAndVisible()
        if let account = Account.current, account.loggedIn {
            NotificationCenter.default.post(signInNotification)
        } else {
            let sessionView = sessionFactory.build()
            dashboard.present(sessionView, animated: false, completion: nil)
        }
        return true
    }
}
