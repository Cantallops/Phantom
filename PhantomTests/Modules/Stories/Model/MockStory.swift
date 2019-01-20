//
//  MockStory.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation
import MobileDocKit
@testable import Phantom

extension Story {
    static let any = Story(
        id: "id",
        uuid: "uuid",
        title: "title",
        slug: nil,
        featureImage: nil,
        featured: false,
        page: false,
        author: nil,
        authors: [.any],
        mobiledoc: MobileDoc(version: "1"),
        html: nil,
        plaintext: nil,
        status: Story.Status.draft,
        excerpt: nil,
        customTemplate: nil,
        tags: [.any],
        updatedAt: Date(),
        publishedAt: nil,
        metaTitle: nil,
        metaDescription: nil
    )

    func setting(title: String) -> Story {
        var story = self
        story.title = title
        return story
    }

    func setting(tags: [Tag]) -> Story {
        var story = self
        story.tags = tags
        return story
    }
}

extension Story.Author {
    static let any = Story.Author(id: "ID", name: "Name")
}
