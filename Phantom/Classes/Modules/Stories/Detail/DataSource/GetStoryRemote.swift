//
//  GetStoryRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 18/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct GetStoryProvider: NetworkProvider {
    let storyId: String

    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/posts/\(storyId)/"
    }
    var queryParameters: JSON {
        return [
            "include": "author, tags",
            "status": "all",
            "formats": "mobiledoc,html"
        ]
    }
    var authenticated: Bool {
        return true
    }
    var contentType: ContentType {
        return .json
    }
}

class GetStoryRemote: DataSource<String, Story> {

    struct StoryRemote: Codable {
        let posts: [Story]

        var story: Story? {
            return posts.first
        }
    }

    override func execute(args: String) -> Result<Story> {
        let provider = GetStoryProvider(storyId: args)
        let result: Result<StoryRemote> = Network(provider: provider).call()
        switch result {
        case .success(let storyRemote):
            if let story = storyRemote.story {
                return .success(story)
            }
            let error = NetworkError(kind: .parse, localizedDescription: "No story found")
            return .failure(error)
        case .failure(let error):
            return .failure(error)
        }
    }
}
