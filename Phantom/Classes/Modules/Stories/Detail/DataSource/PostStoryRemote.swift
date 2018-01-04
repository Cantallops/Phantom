//
//  PostStoryRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct PostStoryProvider: NetworkProvider {
    let story: Story

    var method: HTTPMethod {
        return .POST
    }
    var uri: String {
        return "/posts/"
    }
    var parameters: JSON {
        var post: JSON = [:]
        post["featured"] = story.featured
        post["feature_image"] = story.featureImage
        post["mobiledoc"] = story.mobiledoc
        post["page"] = story.page
        post["featured"] = story.featured
        post["slug"] = story.slug
        post["status"] = story.status.rawValue
        post["title"] = story.title
        post["published_at"] = story.publishedAt?.apiFormated()
        post["custom_excerpt"] = story.excerpt
        post["meta_title"] = story.metaTitle
        post["meta_description"] = story.metaDescription
        return [
            "posts": [post]
        ]
    }

    var queryParameters: JSON {
        return [
            "include": "author, tags",
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

class PostStoryRemote: DataSource<Story, Story> {

    private let storyInternalNC: InternalNotificationCenter<Story>

    init(
        storyInternalNC: InternalNotificationCenter<Story> = storyInternalNotificationCenter
    ) {
        self.storyInternalNC = storyInternalNC
    }

    override func execute(args: Story) -> Result<Story> {
        let provider = PostStoryProvider(story: args)
        let result: Result<StoryRemote> = Network(provider: provider).call()
        switch result {
        case .success(let storyRemote):
            if let story = storyRemote.story {
                let resultStoryDetail = GetStoryRemote().execute(args: story.id)
                if let storyDetail = resultStoryDetail.value {
                    storyInternalNC.post(.StoryNew, object: storyDetail)
                }
                return GetStoryRemote().execute(args: story.id)
            }
            let error = NetworkError(kind: .parse, localizedDescription: "No story found")
            return .failure(error)
        case .failure(let error):
            return .failure(error)
        }
    }
}
