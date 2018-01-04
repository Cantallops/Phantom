//
//  GetMeRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct MeProvider: NetworkProvider {
    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/users/me/"
    }
    var parameters: JSON {
        return [
            "include": "roles"
        ]
    }
    var authenticated: Bool {
        return true
    }
}

class GetMeRemote: DataSource<Any?, TeamMember> {

    struct TeamMemberApi: Codable {
        let users: [TeamMember]

        var user: TeamMember? {
            return users.first
        }
    }

    override func execute(args: Any?) -> Result<TeamMember> {
        let provider = MeProvider()
        let result: Result<TeamMemberApi> = Network(provider: provider).call()
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
