//
//  MockTag.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 25/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation
@testable import Phantom

extension Tag {
    static let any = Tag(
        id: "id",
        name: "name",
        slug: "slug",
        description: nil,
        featureImage: nil,
        metaTitle: nil,
        metaDescription: nil,
        count: nil
    )

    func setting(id: String) -> Tag {
        let tag = Tag(
            id: id,
            name: name,
            slug: slug,
            description: description,
            featureImage: featureImage,
            metaTitle: metaTitle,
            metaDescription: metaDescription,
            count: count
        )
        return tag
    }
}
