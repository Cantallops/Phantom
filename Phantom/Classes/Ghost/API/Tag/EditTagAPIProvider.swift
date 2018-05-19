//
//  EditTagAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct EditTagAPIProvider: NetworkProvider {
    let tag: Tag

    var method: HTTPMethod {
        return .PUT
    }
    var uri: String {
        return "/tags/\(tag.id)"
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
