//
//  MockTeamMember.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation
@testable import Phantom

extension TeamMember {
    static let any = TeamMember(
        id: "id",
        name: "name",
        slug: "slug",
        email: "email",
        status: TeamMember.Status.active,
        roles: [TeamMember.Role(name: TeamMember.Role.Kind.administrator.rawValue)],
        lastSeen: nil
    )
}
