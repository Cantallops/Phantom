//
//  CreateStoryInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class CreateStoryInteractor: Interactor<Story, Story> {
    let createRemote: DataSource<Story, Story>

    init(
        createRemote: DataSource<Story, Story>
    ) {
        self.createRemote = createRemote
        super.init()
    }
    override func execute(args: Story) -> Result<Story> {
        return createRemote.execute(args: args)
    }
}
