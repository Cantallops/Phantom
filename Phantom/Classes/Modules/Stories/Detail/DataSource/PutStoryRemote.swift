//
//  PutStoryRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct PutStoryProvider: NetworkProvider {
    let story: Story

    var method: HTTPMethod {
        return .PUT
    }
    var uri: String {
        return "/posts/\(story.id)/"
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
        post["author"] = story.author?.id

        var jsonTags: [JSON] = []
        for tag in story.tags {
            var jsonTag: JSON = [:]
            if !tag.id.isEmpty {
                jsonTag["id"] = tag.id
            }
            jsonTag["name"] = tag.name
            jsonTags.append(jsonTag)
        }
        post["tags"] = jsonTags
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

struct StoryRemote: Codable {
    struct Object: Codable {
        let id: String
    }
    let posts: [Object]

    var story: Object? {
        return posts.first
    }
}

class PutStoryRemote: DataSource<Story, Story> {

    private let storyInternalNC: InternalNotificationCenter<Story>
    private let tagInternalNC: InternalNotificationCenter<Tag>

    init(
        storyInternalNC: InternalNotificationCenter<Story> = storyInternalNotificationCenter,
        tagInternalNC: InternalNotificationCenter<Tag> = tagInternalNotificationCenter
    ) {
        self.storyInternalNC = storyInternalNC
        self.tagInternalNC = tagInternalNC
    }

    override func execute(args: Story) -> Result<Story> {
        let provider = PutStoryProvider(story: args)
        let result: Result<StoryRemote> = Network(provider: provider).call()
        switch result {
        case .success(let storyRemote):
            if let story = storyRemote.story {
                let resultStoryDetail = GetStoryRemote().execute(args: story.id)
                if let storyDetail = resultStoryDetail.value {
                    sendNotifications(forInitialStory: args, newStory: storyDetail)
                }
                return resultStoryDetail
            }
            let error = NetworkError(kind: .parse, localizedDescription: "No story found")
            return .failure(error)
        case .failure(let error):
            return .failure(error)
        }
    }

    private func sendNotifications(forInitialStory initialStory: Story, newStory: Story) {
        let newTags = initialStory.tags.filter({ $0.isNew })
        for tag in newStory.tags where newTags.contains(where: { $0.name == tag.name }) {
            tagInternalNC.post(.TagNew, object: tag)
        }
        storyInternalNC.post(.StoryEdit, object: newStory)
    }
}
