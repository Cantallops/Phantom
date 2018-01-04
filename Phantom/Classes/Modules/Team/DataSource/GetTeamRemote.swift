//
//  GetTeamRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 18/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct TeamProvider: NetworkProvider {
    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/users/"
    }
    var parameters: JSON {
        return [
            "include": "roles",
            "limit": "all"
        ]
    }
    var authenticated: Bool {
        return true
    }
}

class GetTeamRemote: DataSource<Meta?, Paginated<[TeamMember]>> {

    struct PaginatedTeam: Codable {
        let users: [TeamMember]
        let meta: Meta

        var paginated: Paginated<[TeamMember]> {
            return Paginated<[TeamMember]>(object: users, meta: meta)
        }
    }

    override func execute(args: Meta?) -> Result<Paginated<[TeamMember]>> {
        let provider = TeamProvider()
        let result: Result<PaginatedTeam> = Network(provider: provider).call()
        switch result {
        case .success(let members):
            return .success(members.paginated)
        case .failure(let error):
            return .failure(error)
        }
    }
}
