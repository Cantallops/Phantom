//
//  AccountKeychain.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct AccountKeychain {
    // MARK: Types

    enum KeychainError: Error {
        case noAccount
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError(status: OSStatus)
    }

    // MARK: Properties

    let service: String

    private(set) var accountIdentifier: String

    let accessGroup: String?

    // MARK: Intialization

    init(service: String, accountIdentifier: String, accessGroup: String? = nil) {
        self.service = service
        self.accountIdentifier = accountIdentifier
        self.accessGroup = accessGroup
    }

    // MARK: Keychain access

    func get() throws -> Account {
        /*
         Build a query to find the item that matches the service, account and
         access group.
         */
        var query = AccountKeychain.keychainQuery(
            withService: service,
            account: accountIdentifier,
            accessGroup: accessGroup
        )
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue

        // Try to fetch the existing keychain item that matches the query.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // Check the return status and throw an error if appropriate.
        guard status != errSecItemNotFound else { throw KeychainError.noAccount }
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }

        // Parse the account string from the query result.
        guard let existingItem = queryResult as? [String: AnyObject],
            let data = existingItem[kSecValueData as String] as? Data,
            let account = try? Account.decode(data) else {
                throw KeychainError.unexpectedPasswordData
        }

        return account
    }

    func save(account: Account) throws {
        // Encode the account into an Data object.
        let encodedAccount = try JSONEncoder().encode(account)

        do {
            // Check for an existing item in the keychain.
            try _ = get()

            // Update the existing item with the new account.
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedAccount as AnyObject?
            let query = AccountKeychain.keychainQuery(
                withService: service,
                account: accountIdentifier,
                accessGroup: accessGroup
            )
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else {
                throw KeychainError.unhandledError(status: status)
            }
        } catch KeychainError.noAccount {
            /*
             No account was found in the keychain. Create a dictionary to save
             as a new keychain item.
             */
            var newItem = AccountKeychain.keychainQuery(
                withService: service,
                account: accountIdentifier,
                accessGroup: accessGroup
            )
            newItem[kSecValueData as String] = encodedAccount as AnyObject?

            // Add a the new item to the keychain.
            let status = SecItemAdd(newItem as CFDictionary, nil)

            // Throw an error if an unexpected status was returned.
            guard status == noErr else { throw KeychainError.unhandledError(status: status) }
        }
    }

    mutating func renameAccount(_ newAccountName: String) throws {
        // Try to update an existing item with the new account name.
        var attributesToUpdate = [String: AnyObject]()
        attributesToUpdate[kSecAttrAccount as String] = newAccountName as AnyObject?

        let query = AccountKeychain.keychainQuery(
            withService: service,
            account: self.accountIdentifier,
            accessGroup: accessGroup
        )
        let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)

        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }

        self.accountIdentifier = newAccountName
    }

    func deleteItem() throws {
        // Delete the existing item from the keychain.
        let query = AccountKeychain.keychainQuery(
            withService: service,
            account: accountIdentifier,
            accessGroup: accessGroup
        )
        let status = SecItemDelete(query as CFDictionary)

        // Throw an error if an unexpected status was returned.
        guard status == noErr || status == errSecItemNotFound else {
            throw KeychainError.unhandledError(status: status)
        }
    }

    static func accounts(forService service: String, accessGroup: String? = nil) throws -> [AccountKeychain] {
        // Build a query for all items that match the service and access group.
        var query = AccountKeychain.keychainQuery(withService: service, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitAll
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanFalse

        // Fetch matching items from the keychain.
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        // If no items were found, return an empty array.
        guard status != errSecItemNotFound else { return [] }

        // Throw an error if an unexpected status was returned.
        guard status == noErr else { throw KeychainError.unhandledError(status: status) }

        // Cast the query result to an array of dictionaries.
        guard let resultData = queryResult as? [[String: AnyObject]] else { throw KeychainError.unexpectedItemData }

        // Create a `AccountKeychain` for each dictionary in the query result.
        var accounts = [AccountKeychain]()
        for result in resultData {
            guard let accountIdentifier  = result[kSecAttrAccount as String] as? String else {
                throw KeychainError.unexpectedItemData
            }
            let accountItem = AccountKeychain(
                service: service,
                accountIdentifier: accountIdentifier,
                accessGroup: accessGroup
            )
            accounts.append(accountItem)
        }

        return accounts
    }

    // MARK: Convenience

    private static func keychainQuery(
        withService service: String,
        account: String? = nil,
        accessGroup: String? = nil
    ) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?

        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }

        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }

        return query
    }
}
