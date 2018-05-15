//
//  Account.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private let kAccountService = "accountService"

struct Account: Codable {
    var blogUrl: String
    var apiVersion: String
    var username: String
    var clientKeys: ClientKeys?
    var oauth: Oauth?

    var loggedIn: Bool {
        return oauth != nil && clientKeys != nil
    }

    var identifier: String {
        return "\(blogUrl)+\(username)"
    }

    mutating func signOut() {
        oauth = nil
        clientKeys = nil
        save()
    }
}

extension Account {
    var storyIndexDomain: String {
        return "\(Story.searcheableDomain)+\(identifier)"
    }

    var preferences: Preferences {
        return Preferences(suiteName: blogUrl)!
    }
}

extension Account {
    static var current: Account? {
        didSet {
            if let current = current {
                last = current
                if !current.username.isEmpty {
                    current.updateAccountIdentifier(.current)
                }
                current.save()
            } else {
                oldValue?.removeAccountIdentifier(.current)
            }

        }
    }

    static var last: Account? {
        didSet {
            if let last = last {
                if !last.username.isEmpty {
                    last.updateAccountIdentifier(.last)
                }
            } else {
                oldValue?.removeAccountIdentifier(.last)
            }
        }
    }

    enum KIdentifiers: String {
        case last = "lastAccountIdentifier"
        case current = "currentAccountIdentifier"
    }

    fileprivate static func getAccountIdentifier(_ identifier: KIdentifiers) -> String? {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: identifier.rawValue)
    }

    fileprivate func updateAccountIdentifier(_ identifier: KIdentifiers) {
        let defaults = UserDefaults.standard
        defaults.set(self.identifier, forKey: identifier.rawValue)
        defaults.synchronize()
    }

    fileprivate func removeAccountIdentifier(_ identifier: KIdentifiers) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: identifier.rawValue)
        defaults.synchronize()
    }
}

extension Account {

    func save() {
        if username.isEmpty { // Avoid anonymous account to be saved
            return
        }
        try? Account.getKeychain(forIdentifier: identifier).save(account: self)
    }

    static func load() {
        Account.current = get(forIdentifier: .current)
        Account.last = get(forIdentifier: .last)
    }

    private static func get(forIdentifier identifier: KIdentifiers) -> Account? {
        guard let accountIdentifier = getAccountIdentifier(identifier) else {
            return nil
        }
        let account = try? getKeychain(forIdentifier: accountIdentifier).get()
        return account
    }

    static func getKeychain(forIdentifier identifier: String) -> AccountKeychain {
        let keychains = (try? AccountKeychain.accounts(forService: kAccountService)) ?? []
        let keychain = keychains.first { keychain -> Bool in
            guard let account = try? keychain.get() else {
                return false
            }
            return account.identifier == identifier
        }
        return keychain ?? AccountKeychain(service: kAccountService, accountIdentifier: identifier)
    }
}
