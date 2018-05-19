//
//  DeleteStoryRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class DeleteStoryRemote: DataSource<Story, Story> {

    private let storyInternalNC: InternalNotificationCenter<Story>

    init(
        storyInternalNC: InternalNotificationCenter<Story> = storyInternalNotificationCenter
    ) {
        self.storyInternalNC = storyInternalNC
    }

    override func execute(args: Story) -> Result<Story> {
        let provider = DeletePostAPIProvider(story: args)
        let result: Result<Data> = Network().call(provider: provider)
        switch result {
        case .success:
            storyInternalNC.post(.storyDelete, object: args)
            return .success(args)
        case .failure(let error):
            return .failure(error)
        }
    }
}
