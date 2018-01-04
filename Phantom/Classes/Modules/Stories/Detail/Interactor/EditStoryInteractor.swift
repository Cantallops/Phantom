//
//  EditStoryInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 11/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class EditStoryInteractor: Interactor<Story, Story> {
    let editRemote: DataSource<Story, Story>

    init(
        editRemote: DataSource<Story, Story>
    ) {
        self.editRemote = editRemote
        super.init()
    }
    override func execute(args: Story) -> Result<Story> {
        return editRemote.execute(args: args)
    }
}
