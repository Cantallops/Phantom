//
//  DeleteTagRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 02/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct DeleteTagProvider: NetworkProvider {
    let tag: Tag

    var method: HTTPMethod {
        return .DELETE
    }
    var uri: String {
        return "/tags/\(tag.id)"
    }
    var authenticated: Bool {
        return true
    }
}

class DeleteTagRemote: DataSource<Tag, Tag> {

    private let internalNotificationCenter: InternalNotificationCenter<Tag>

    init(
        internalNotificationCenter: InternalNotificationCenter<Tag> = tagInternalNotificationCenter
    ) {
        self.internalNotificationCenter = internalNotificationCenter
    }

    override func execute(args: Tag) -> Result<Tag> {
        let provider = DeleteTagProvider(tag: args)
        let result: Result<Data> = Network(provider: provider).call()
        switch result {
        case .success:
            internalNotificationCenter.post(.TagDelete, object: args)
            return .success(args)
        case .failure(let error):
            return .failure(error)
        }
    }
}
