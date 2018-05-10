//
//  DeleteStoryInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class DeleteStoryInteractor: Interactor<Story, Story> {
    let deleteRemote: DataSource<Story, Story>

    init(
        deleteRemote: DataSource<Story, Story>
    ) {
        self.deleteRemote = deleteRemote
        super.init()
    }
    override func execute(args: Story) -> Result<Story> {
        return deleteRemote.execute(args: args)
    }
}
