//
//  GetTagListRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 02/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetTagListRemote: DataSource<Meta?, Paginated<[Tag]>> {

    struct PaginatedTags: Codable {
        let tags: [Tag]
        let meta: Meta

        var paginated: Paginated<[Tag]> {
            return Paginated<[Tag]>(object: tags, meta: meta)
        }
    }

    override func execute(args: Meta?) -> Result<Paginated<[Tag]>> {
        let provider = BrowseTagsAPIProvider()
        let result: Result<PaginatedTags> = Network().call(provider: provider)
        switch result {
        case .success(let paginatedTags):
            return .success(paginatedTags.paginated)
        case .failure(let error):
            return .failure(error)
        }
    }
}
