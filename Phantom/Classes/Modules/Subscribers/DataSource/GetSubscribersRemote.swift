//
//  GetSubscribersRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct SubscribersProvider: NetworkProvider {

    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/subscribers/"
    }
    var parameters: JSON {
        let params: JSON = [
            "limit": "all"
        ]
        return params
    }
    var authenticated: Bool {
        return true
    }
}

class GetSubscribersRemote: DataSource<Meta?, Paginated<[Subscriber]>> {

    struct PaginatedSubscribers: Codable {
        let subscribers: [Subscriber]
        let meta: Meta

        var paginated: Paginated<[Subscriber]> {
            return Paginated<[Subscriber]>(object: subscribers, meta: meta)
        }
    }

    override func execute(args: Meta?) -> Result<Paginated<[Subscriber]>> {
        let provider = SubscribersProvider()
        let result: Result<PaginatedSubscribers> = Network(provider: provider).call()
        switch result {
        case .success(let paginated):
            return .success(paginated.paginated)
        case .failure(let error):
            return .failure(error)
        }
    }
}
