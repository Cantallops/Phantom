//
//  GetSubscribersRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetSubscribersRemote: DataSource<Meta?, Paginated<[Subscriber]>> {

    struct PaginatedSubscribers: Codable {
        let subscribers: [Subscriber]
        let meta: Meta

        var paginated: Paginated<[Subscriber]> {
            return Paginated<[Subscriber]>(object: subscribers, meta: meta)
        }
    }

    override func execute(args: Meta?) -> Result<Paginated<[Subscriber]>> {
        let provider = SubscribersAPIProvider()
        let result: Result<PaginatedSubscribers> = Network().call(provider: provider)
        switch result {
        case .success(let paginated):
            return .success(paginated.paginated)
        case .failure(let error):
            return .failure(error)
        }
    }
}
