//
//  UserPreferences+Rate.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

extension UserDefaults {
    private static let kRateShownDateKey = "rateShownDate"
    var rateShownDate: Date {
        get {
            guard object(forKey: UserDefaults.kRateShownDateKey) != nil else {
                let date = Date()
                set(date.timeIntervalSince1970, forKey: UserDefaults.kRateShownDateKey)
                return date
            }
            let timeInterval = double(forKey: UserDefaults.kRateShownDateKey)
            return Date(timeIntervalSince1970: timeInterval)
        }
        set {
            let timeInterval = newValue.timeIntervalSince1970
            set(timeInterval, forKey: UserDefaults.kRateShownDateKey)
        }
    }
}
