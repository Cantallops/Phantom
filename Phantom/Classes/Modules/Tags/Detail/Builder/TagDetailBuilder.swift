//
//  TagDetailBuilder.swift
//  Phantom
//
//  Created by Alberto Cantallops on 28/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TagDetailBuilder: Builder<Tag?, UIViewController> {
    override func build(arg: Tag?) -> UIViewController {
        let presenter = TagDetailPresenter(
            tag: arg,
            createInteractor: CreateTagInteractor(createTagRemote: PostTagRemote()),
            editInteractor: EditTagInteractor(editTagRemote: PutTagRemote()),
            deleteInteractor: DeleteTagInteractor(deleteTagRemote: DeleteTagRemote()),
            metaDataBuilder: MetaDataBuilder()
        )
        let view = TagDetailView(presenter: presenter)
        presenter.view = view
        return view
    }
}
