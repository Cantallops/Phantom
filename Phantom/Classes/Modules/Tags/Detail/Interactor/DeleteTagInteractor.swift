//
//  DeleteTagInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 01/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class DeleteTagInteractor: Interactor<Tag, Tag> {
    let deleteTagRemote: DataSource<Tag, Tag>

    init(
        deleteTagRemote: DataSource<Tag, Tag>
    ) {
        self.deleteTagRemote = deleteTagRemote
        super.init()
    }

    override func execute(args: Tag) -> Result<Tag> {
        return deleteTagRemote.execute(args: args)
    }
}
