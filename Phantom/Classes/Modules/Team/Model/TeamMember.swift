//
//  TeamMember.swift
//  Phantom
//
//  Created by Alberto Cantallops on 10/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct TeamMember: Codable {
    let id: String
    var name: String
    var slug: String
    let email: String
    var status: Status
    var roles: [Role]
    var lastSeen: Date?

    var role: Role.Kind {
        return roles.first?.kind ?? .author
    }

    struct Role: Codable {
        let name: String

        var kind: Kind {
            return Kind(rawValue: name) ?? .unknown
        }
        enum Kind: String {
            case administrator = "Administrator"
            case editor = "Editor"
            case author = "Author"
            case owner = "Owner"
            case unknown
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case email
        case status
        case roles
        case lastSeen = "last_seen"
    }

    enum Status: String, Codable {
        case active = "active"
        case inactive = "inactive"
        case locked = "locked"
        // Password attempts
        case warn1 = "warn-1"
        case warn2 = "warn-2"
        case warn3 = "warn-3"
        case warn4 = "warn-4"

        // Locked should be inactive but it is really an active user
        // but it does not be able to log in without reset password
        static let activeStatus: [Status] = [.active, .warn1, .warn2, .warn3, .warn4, .locked]
        static let inactiveStatus: [Status] = [.inactive]

        func isActiveStatus() -> Bool {
            return Status.activeStatus.contains(self)
        }
        func isInactiveStatus() -> Bool {
            return Status.inactiveStatus.contains(self)
        }
    }
}

extension TeamMember {
    var author: Story.Author {
        return Story.Author(id: id, name: name)
    }
}
