//
//  GetTagListRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 02/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct TagListProvider: NetworkProvider {
    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/tags/"
    }
    var parameters: JSON {
        return [
            "limit": "all",
            "include": "count.posts"
        ]
    }
    var authenticated: Bool {
        return true
    }
}

class GetTagListRemote: DataSource<Meta?, Paginated<[Tag]>> {

    struct PaginatedTags: Codable {
        let tags: [Tag]
        let meta: Meta

        var paginated: Paginated<[Tag]> {
            return Paginated<[Tag]>(object: tags, meta: meta)
        }
    }

    override func execute(args: Meta?) -> Result<Paginated<[Tag]>> {
        let provider = TagListProvider()
        let result: Result<PaginatedTags> = Network(provider: provider).call()
        switch result {
        case .success(let paginatedTags):
            return .success(paginatedTags.paginated)
        case .failure(let error):
            return .failure(error)
        }
    }
}
