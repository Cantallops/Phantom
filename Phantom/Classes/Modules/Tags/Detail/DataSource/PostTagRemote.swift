//
//  PostTagRemote.swift
//  Phantom
//
//  Created by Alberto Cantallops on 02/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct PostTagProvider: NetworkProvider {
    let tag: Tag

    var method: HTTPMethod {
        return .POST
    }
    var uri: String {
        return "/tags"
    }
    var parameters: JSON {
        return [
            "tags": [
                [
                    "name": tag.name,
                    "slug": tag.slug,
                    "description": tag.description,
                    "meta_title": tag.metaTitle,
                    "meta_description": tag.metaDescription,
                    "feature_image": tag.featureImage
                ]
            ]
        ]
    }
    var authenticated: Bool {
        return true
    }
    var contentType: ContentType {
        return .json
    }
}

class PostTagRemote: DataSource<Tag, Tag> {

    private let internalNotificationCenter: InternalNotificationCenter<Tag>

    init(
        internalNotificationCenter: InternalNotificationCenter<Tag> = tagInternalNotificationCenter
    ) {
        self.internalNotificationCenter = internalNotificationCenter
    }

    override func execute(args: Tag) -> Result<Tag> {
        let provider = PostTagProvider(tag: args)
        let result: Result<TagRemote> = Network(provider: provider).call()
        switch result {
        case .success(let tagRemote):
            if let tag = tagRemote.tag {
                internalNotificationCenter.post(.tagNew, object: tag)
                return .success(tag)
            }
            let error = NetworkError(kind: .parse, localizedDescription: "No tag found")
            return .failure(error)
        case .failure(let error):
            return .failure(error)
        }
    }
}
