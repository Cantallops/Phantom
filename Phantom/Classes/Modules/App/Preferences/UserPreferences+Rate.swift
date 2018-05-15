//
//  UserPreferences+Rate.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

extension Preferences {
    private static let kRateShownDateKey = "rateShownDate"
    var rateShownDate: Date {
        get {
            guard object(forKey: Preferences.kRateShownDateKey) != nil else {
                let date = Date()
                set(date.timeIntervalSince1970, forKey: Preferences.kRateShownDateKey)
                return date
            }
            let timeInterval = double(forKey: Preferences.kRateShownDateKey)
            return Date(timeIntervalSince1970: timeInterval)
        }
        set {
            let timeInterval = newValue.timeIntervalSince1970
            set(timeInterval, forKey: Preferences.kRateShownDateKey)
        }
    }
}
