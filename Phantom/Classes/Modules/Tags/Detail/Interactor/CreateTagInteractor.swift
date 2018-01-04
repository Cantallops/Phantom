//
//  CreateTagInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class CreateTagInteractor: Interactor<Tag, Tag> {
    let createTagRemote: DataSource<Tag, Tag>

    init(
        createTagRemote: DataSource<Tag, Tag>
    ) {
        self.createTagRemote = createTagRemote
        super.init()
    }

    override func execute(args: Tag) -> Result<Tag> {
        return createTagRemote.execute(args: args)
    }
}
