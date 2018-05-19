//
//  PutTagRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 02/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct TagRemote: Codable {
    let tags: [Tag]

    var tag: Tag? {
        return tags.first
    }
}

class PutTagRemote: DataSource<Tag, Tag> {

    private let internalNotificationCenter: InternalNotificationCenter<Tag>

    init(
        internalNotificationCenter: InternalNotificationCenter<Tag> = tagInternalNotificationCenter
    ) {
        self.internalNotificationCenter = internalNotificationCenter
    }

    override func execute(args: Tag) -> Result<Tag> {
        let provider = EditTagAPIProvider(tag: args)
        let result: Result<TagRemote> = Network().call(provider: provider)
        switch result {
        case .success(let tagRemote):
            if let tag = tagRemote.tag {
                internalNotificationCenter.post(.tagEdit, object: tag)
                return .success(tag)
            }
            let error = NetworkError(kind: .parse, localizedDescription: "No tag found")
            return .failure(error)
        case .failure(let error):
            return .failure(error)
        }
    }
}
