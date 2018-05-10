//
//  DeleteStoryRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct DeleteStoryProvider: NetworkProvider {
    let story: Story

    var method: HTTPMethod {
        return .DELETE
    }
    var uri: String {
        return "/posts/\(story.id)/"
    }

    var authenticated: Bool {
        return true
    }
    var contentType: ContentType {
        return .json
    }
}

class DeleteStoryRemote: DataSource<Story, Story> {

    private let storyInternalNC: InternalNotificationCenter<Story>

    init(
        storyInternalNC: InternalNotificationCenter<Story> = storyInternalNotificationCenter
    ) {
        self.storyInternalNC = storyInternalNC
    }

    override func execute(args: Story) -> Result<Story> {
        let provider = DeleteStoryProvider(story: args)
        let result: Result<Data> = Network(provider: provider).call()
        switch result {
        case .success:
            storyInternalNC.post(.storyDelete, object: args)
            return .success(args)
        case .failure(let error):
            return .failure(error)
        }
    }
}
