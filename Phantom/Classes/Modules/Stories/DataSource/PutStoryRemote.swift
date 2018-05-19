//
//  PutStoryRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

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
        let provider = EditPostAPIProvider(story: args)
        let result: Result<StoryRemote> = Network().call(provider: provider)
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
            tagInternalNC.post(.tagNew, object: tag)
        }
        storyInternalNC.post(.storyEdit, object: newStory)
    }
}
