//
//  Bundle.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/02/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

extension Bundle {
    var appName: String {
        return (infoDictionary?["CFBundleDisplayName"] as? String)!
    }

    var versionNumber: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String)!
    }

    var buildNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String)!
    }
}
