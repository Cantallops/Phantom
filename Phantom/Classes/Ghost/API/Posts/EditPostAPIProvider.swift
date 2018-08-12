//
//  EditPostAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct EditPostAPIProvider: NetworkProvider {
    let story: Story

    var method: HTTPMethod {
        return .PUT
    }

    var uri: String {
        return "/posts/\(story.id)/"
    }

    var parameters: JSON {
        var post: JSON = [:]
        post["featured"] = story.featured
        post["feature_image"] = story.featureImage
        post["mobiledoc"] = story.mobiledocString
        post["page"] = story.page
        post["featured"] = story.featured
        post["slug"] = story.slug
        post["status"] = story.status.rawValue
        post["title"] = story.title
        post["published_at"] = story.publishedAt?.apiFormated()
        post["custom_excerpt"] = story.excerpt
        post["meta_title"] = story.metaTitle
        post["meta_description"] = story.metaDescription
        post["custom_template"] = story.customTemplate

        var jsonAuthors: [JSON] = []
        for author in story.getAuthors() {
            var jsonAuthor: JSON = [:]
            jsonAuthor["id"] = author.id
            jsonAuthor["name"] = author.name
            jsonAuthors.append(jsonAuthor)
        }
        post["authors"] = jsonAuthors
        var jsonTags: [JSON] = []
        for tag in story.tags {
            var jsonTag: JSON = [:]
            if !tag.id.isEmpty {
                jsonTag["id"] = tag.id
            }
            jsonTag["name"] = tag.name
            jsonTags.append(jsonTag)
        }
        post["tags"] = jsonTags
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
