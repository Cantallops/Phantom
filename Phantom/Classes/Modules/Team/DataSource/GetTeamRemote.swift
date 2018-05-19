//
//  GetTeamRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 18/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetTeamRemote: DataSource<Meta?, Paginated<[TeamMember]>> {

    struct PaginatedTeam: Codable {
        let users: [TeamMember]
        let meta: Meta

        var paginated: Paginated<[TeamMember]> {
            return Paginated<[TeamMember]>(object: users, meta: meta)
        }
    }

    override func execute(args: Meta?) -> Result<Paginated<[TeamMember]>> {
        let provider = BrowseUsersAPIProvider()
        let result: Result<PaginatedTeam> = Network().call(provider: provider)
        switch result {
        case .success(let members):
            return .success(members.paginated)
        case .failure(let error):
            return .failure(error)
        }
    }
}
