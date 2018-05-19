//
//  DeleteTagRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 02/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class DeleteTagRemote: DataSource<Tag, Tag> {

    private let internalNotificationCenter: InternalNotificationCenter<Tag>

    init(
        internalNotificationCenter: InternalNotificationCenter<Tag> = tagInternalNotificationCenter
    ) {
        self.internalNotificationCenter = internalNotificationCenter
    }

    override func execute(args: Tag) -> Result<Tag> {
        let provider = DeleteTagAPIProvider(tag: args)
        let result: Result<Data> = Network().call(provider: provider)
        switch result {
        case .success:
            internalNotificationCenter.post(.tagDelete, object: args)
            return .success(args)
        case .failure(let error):
            return .failure(error)
        }
    }
}
