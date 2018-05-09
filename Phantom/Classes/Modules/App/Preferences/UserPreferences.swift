//
//  UserPreferences.swift
//  Phantom
//
//  Created by Alberto Cantallops on 08/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

let indexStoriesNotificationCenter = InternalNotificationCenter<Bool>()
extension InternalNotification {
    static let indexStories = InternalNotification(name: "IndexStories")
}

extension UserDefaults {
    private static let kIndexStoriesKey = "IndexStories"
    var indexStories: Bool {
        get {
            guard object(forKey: UserDefaults.kIndexStoriesKey) != nil else {
                return true
            }
            return bool(forKey: UserDefaults.kIndexStoriesKey)
        }
        set {
            set(newValue, forKey: UserDefaults.kIndexStoriesKey)
            indexStoriesNotificationCenter.post(.indexStories, object: newValue)
        }
    }

}
