//
//  GeneralSettings.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct GeneralSettings: Codable {
    struct Setting: Codable {
        let id: String
        let key: Key
        let value: String
        let type: Kind

        enum Key: String, Codable {
            case title
            case description
            case logo
            case coverImage = "cover_image"
            case icon
            case defaultLocale = "default_locale"
            case activeTimezone = "active_timezone"
            case forceI18n = "force_i18n"
            case permalinks
            case amp
            case ghostHead = "ghost_head"
            case ghostFoot = "ghost_foot"
            case facebook
            case twitter
            case labs
            case navigation
            case slack
            case unsplash
            case activeTheme = "active_theme"
            case activeApps = "active_apps"
            case installedApps = "installed_apps"
            case isPrivate = "is_private"
            case password
            case publicHash = "public_hash"
        }

        enum Kind: String, Codable {
            case app
            case blog
            case `private`
            case theme
        }
    }

    let settings: [Setting]

    func setting(withKey key: Setting.Key) -> Setting? {
        return settings.first(where: { $0.key == key })
    }

    var isSubscribersEnabled: Bool {
        guard let setting = setting(withKey: .labs),
            let data = setting.value.data(using: .utf8),
            let labsSetting = try? LabsSetting.decode(data) else {
            return false
        }
        return labsSetting.subscribers ?? false
    }
}

struct LabsSetting: Codable {
    let publicAPI: Bool?
    let subscribers: Bool?
}
