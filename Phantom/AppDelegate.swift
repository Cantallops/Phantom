//
//  AppDelegate.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    var checkRunningTest: Bool = true

    var services: [UIApplicationDelegate] = [
        LoggerService(),
        LoadStateService(),
        LoadUIAppearanceService(),
        InitialModuleService(),
        SearcheableIndexService()
    ]

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        #if DEBUG
        if checkRunningTest && isRunningTests {
            return TestService().application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        #endif
        for service in services {
            if let serviceResult = service.application?(application, didFinishLaunchingWithOptions: launchOptions) {
                if !serviceResult {
                    return false
                }
            }
        }
        return true
    }

    func application(
        _ application: UIApplication,
        continue userActivity: NSUserActivity,
        restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
        for service in services {
            if let serviceResult = service.application?(
                application,
                continue: userActivity,
                restorationHandler: restorationHandler
            ) {
                if !serviceResult {
                    return false
                }
            }
        }
        return true
    }
}

#if DEBUG
extension UIApplicationDelegate {
    var isRunningTests: Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
#endif
