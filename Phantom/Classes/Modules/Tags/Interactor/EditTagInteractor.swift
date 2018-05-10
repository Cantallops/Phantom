//
//  EditTagInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class EditTagInteractor: Interactor<Tag, Tag> {
    let editTagRemote: DataSource<Tag, Tag>

    init(
        editTagRemote: DataSource<Tag, Tag>
    ) {
        self.editTagRemote = editTagRemote
        super.init()
    }

    override func execute(args: Tag) -> Result<Tag> {
        return editTagRemote.execute(args: args)
    }
}
