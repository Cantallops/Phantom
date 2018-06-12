//
//  AddPostAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct AddPostAPIProvider: NetworkProvider {
    let story: Story

    var method: HTTPMethod {
        return .POST
    }

    var uri: String {
        return "/posts/"
    }

    var parameters: JSON {
        var post: JSON = [:]
        post["featured"] = story.featured
        post["feature_image"] = story.featureImage
        post["mobiledoc"] = story.mobiledoc
        post["page"] = story.page
        post["featured"] = story.featured
        post["slug"] = story.slug
        post["status"] = story.status.rawValue
        post["title"] = story.title
        post["published_at"] = story.publishedAt?.apiFormated()
        post["custom_excerpt"] = story.excerpt
        post["meta_title"] = story.metaTitle
        post["meta_description"] = story.metaDescription
        return [
            "posts": [post]
        ]
    }

    var queryParameters: JSON {
        return [
            "include": "author,authors,tags",
            "formats": "mobiledoc,html"
        ]
    }

    var authenticated: Bool {
        return true
    }

    var contentType: ContentType {
        return .json
    }
}
