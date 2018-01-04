//
//  Tag.swift
//  Phantom
//
//  Created by Alberto Cantallops on 28/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct Tag: Codable {
    let id: String
    var name: String
    var slug: String

    var description: String?
    var featureImage: String?

    var metaTitle: String?
    var metaDescription: String?

    var count: Count?

    struct Count: Codable {
        var posts: Int
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case slug
        case description
        case featureImage = "feature_image"
        case metaTitle = "meta_title"
        case metaDescription = "meta_description"
        case count
    }
}

extension Tag: Equatable {
    static func == (lhs: Tag, rhs: Tag) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.slug != rhs.slug {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.featureImage != rhs.featureImage {
            return false
        }
        if lhs.metaTitle != rhs.metaTitle {
            return false
        }
        if lhs.metaDescription != rhs.metaDescription {
            return false
        }
        return true
    }
}

extension Tag {
    var isNew: Bool {
        return id.isEmpty
    }
}

extension Tag {
    var metaData: MetaData {
        set {
            metaTitle = newValue.title
            metaDescription = newValue.description
        }
        get {
            return MetaData(
                title: metaTitle ?? "",
                description: metaDescription ?? "",
                titleDefault: name,
                descriptionDefault: description
            )
        }
    }
}
