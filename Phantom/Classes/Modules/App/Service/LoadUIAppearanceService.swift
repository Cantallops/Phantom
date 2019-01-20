//
//  LoadUIAppearanceService.swift
//  Phantom
//
//  Created by Alberto Cantallops on 18/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
#if DEBUG
import SimulatorStatusMagiciOS
#endif

class LoadUIAppearanceService: NSObject, UIApplicationDelegate {
    #if DEBUG
    var isRunningScreenshotTests: Bool {
        return ProcessInfo.processInfo.environment["SIMULATOR_STATUS_MAGIC_OVERRIDES"] == "enable"
    }
    #endif

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        application.delegate?.window??.tintColor = Color.tint

        #if DEBUG
        if isRunningScreenshotTests {
            let statusBarManager: SDStatusBarManager = SDStatusBarManager.sharedInstance()
            statusBarManager.carrierName = "Phantom"
            statusBarManager.bluetoothState = .hidden
            statusBarManager.batteryDetailEnabled = false
            statusBarManager.networkType = .typeLTE
            statusBarManager.enableOverrides()
        }
        #endif

        return true
    }
}
