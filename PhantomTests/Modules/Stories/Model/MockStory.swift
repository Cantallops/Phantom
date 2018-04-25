//
//  MockStory.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation
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
        mobiledoc: Story.MobileDoc(),
        html: nil,
        plaintext: nil,
        status: Story.Status.draft,
        excerpt: nil,
        tags: [],
        updatedAt: Date(),
        publishedAt: nil,
        metaTitle: nil,
        metaDescription: nil
    )

    func settingTitle(title: String) -> Story {
        var story = self
        story.title = title
        return story
    }
}
