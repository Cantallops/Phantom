//
//  GetMeRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetMeRemote: DataSource<Any?, TeamMember> {

    struct TeamMemberApi: Codable {
        let users: [TeamMember]

        var user: TeamMember? {
            return users.first
        }
    }

    override func execute(args: Any?) -> Result<TeamMember> {
        let provider = ReadUserAPIProvider(id: "me")
        let result: Result<TeamMemberApi> = Network().call(provider: provider)
        switch result {
        case .success(let members):
            guard let user = members.user else {
                let error = NetworkError(kind: .parse, localizedDescription: "No current user found")
                return .failure(error)
            }
            return .success(user)
        case .failure(let error):
            return .failure(error)
        }
    }
}
