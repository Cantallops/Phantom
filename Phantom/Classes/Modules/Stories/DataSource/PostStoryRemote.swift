//
//  PostStoryRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class PostStoryRemote: DataSource<Story, Story> {

    private let storyInternalNC: InternalNotificationCenter<Story>

    init(
        storyInternalNC: InternalNotificationCenter<Story> = storyInternalNotificationCenter
    ) {
        self.storyInternalNC = storyInternalNC
    }

    override func execute(args: Story) -> Result<Story> {
        let provider = AddPostAPIProvider(story: args)
        let result: Result<StoryRemote> = Network().call(provider: provider)
        switch result {
        case .success(let storyRemote):
            if let story = storyRemote.story {
                let resultStoryDetail = GetStoryRemote().execute(args: story.id)
                if let storyDetail = resultStoryDetail.value {
                    storyInternalNC.post(.storyNew, object: storyDetail)
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
