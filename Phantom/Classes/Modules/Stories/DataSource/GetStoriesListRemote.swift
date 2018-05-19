//
//  GetStoriesListRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetStoriesListRemote: DataSource<Meta?, Paginated<[Story]>> {

    private let getMe: Interactor<Any?, TeamMember>

    init(getMe: Interactor<Any?, TeamMember> = GetMeInteractor()) {
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
        let provider = BrowsePostsAPIProvider(authorToFilter: authorToFilter())
        let result: Result<PaginatedStories> = Network().call(provider: provider)
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
