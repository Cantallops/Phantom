//
//  GetStoriesListRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct StoriesListProvider: NetworkProvider {
    var authorToFilter: String?

    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/posts/"
    }
    var parameters: JSON {
        var params: JSON = [
            "limit": "all",
            "status": "all",
            "include": "author,tags",
            "staticPages": "all",
            "formats": "mobiledoc,html,plaintext"
        ]
        if let authorToFilter = authorToFilter {
            params["filter"] = "author:\(authorToFilter)"
        }
        return params
    }
    var authenticated: Bool {
        return true
    }
}

class GetStoriesListRemote: DataSource<Meta?, Paginated<[Story]>> {

    private let getMe: Interactor<Any?, TeamMember>

    init(getMe: Interactor<Any?, TeamMember> = GetMe()) {
        self.getMe = getMe
    }
    struct PaginatedStories: Codable {
        let posts: [Story]
        let meta: Meta

        var paginated: Paginated<[Story]> {
            return Paginated<[Story]>(object: posts, meta: meta)
        }
    }

    override func execute(args: Meta?) -> Result<Paginated<[Story]>> {
        let provider = StoriesListProvider(authorToFilter: authorToFilter())
        let result: Result<PaginatedStories> = Network(provider: provider).call()
        switch result {
        case .success(let paginatedStories):
            return .success(paginatedStories.paginated)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func authorToFilter() -> String? {
        let meResult: Result<TeamMember> = getMe.execute(args: nil)
        guard let me = meResult.value, me.role == .author else {
            return nil
        }
        return me.slug
    }
}
