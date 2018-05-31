//
//  UserPreferences+Editor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 14/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

extension Preferences {
    private static let kAutocorrection = "autocorrection"
    var autocorrection: Bool {
        get {
            guard object(forKey: Preferences.kAutocorrection) != nil else {
                return true
            }
            return bool(forKey: Preferences.kAutocorrection)
        }
        set {
            set(newValue, forKey: Preferences.kAutocorrection)
        }
    }

    private static let kSpellChecking = "spellChecking"
    var spellChecking: Bool {
        get {
            guard object(forKey: Preferences.kSpellChecking) != nil else {
                return true
            }
            return bool(forKey: Preferences.kSpellChecking)
        }
        set {
            set(newValue, forKey: Preferences.kSpellChecking)
        }
    }

    private static let kAutocapitalization = "autocapitalization"
    var autocapitalization: Bool {
        get {
            guard object(forKey: Preferences.kAutocapitalization) != nil else {
                return true
            }
            return bool(forKey: Preferences.kAutocapitalization)
        }
        set {
            set(newValue, forKey: Preferences.kAutocapitalization)
        }
    }
}
