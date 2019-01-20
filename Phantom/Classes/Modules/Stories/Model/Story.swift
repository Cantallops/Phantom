//
//  Story.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
import MobileDocKit

struct Story {
    let id: String
    let uuid: String
    var title: String
    var slug: String?
    var featureImage: String?
    var featured: Bool
    var page: Bool
    var author: Author?
    var authors: [Author]?
    var mobiledoc: MobileDoc?
    var html: HTML?
    var plaintext: String?
    var status: Status
    var excerpt: String?
    var customTemplate: String?

    var tags: [Tag]

    var updatedAt: Date
    var publishedAt: Date?

    var metaTitle: String?
    var metaDescription: String?

    typealias HTML = String
    typealias Markdown = String

    enum Status: String, Codable {
        case published
        case draft
        case scheduled
    }

    struct Author: Codable, Equatable {
        let id: String
        var name: String
    }

    var markdown: Markdown {
        get {
            if let mobiledoc = self.mobiledoc {
                if let card = mobiledoc.cards.first as? GhostMarkdownCard {
                    return card.markdown
                } else if let card = mobiledoc.cards.first as? MarkdownCard {
                    return card.markdown
                }
            }
            return ""
        }
        set {
            mobiledoc = MobileDoc(
                version: "0.3.1",
                cards: [GhostMarkdownCard(markdown: newValue)],
                sections: [CardSection(cardIndex: 0)]
            )
        }
    }
    var editedWithKoeingEditor: Bool {
        if let mobiledoc = self.mobiledoc {
            guard let firstCard = mobiledoc.cards.first,
                firstCard.canBeEditedWithBasicEditor() else {
                    return true
            }
            return mobiledoc.sections.count > 2
                || mobiledoc.cards.count != 1
                || !mobiledoc.markups.isEmpty
                || !mobiledoc.atoms.isEmpty
        }
        return false
    }

    var mobiledocString: String? {
        let mobiledocEncoder = MobileDocEncoder()
        guard
            let mobiledoc = mobiledoc,
            let jsonMobileDoc = try? mobiledocEncoder.encode(mobiledoc),
            let jsonMobileDocData = try? JSONSerialization.data(withJSONObject: jsonMobileDoc) else {
                return nil
        }
        return String(data: jsonMobileDocData, encoding: .utf8)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case uuid
        case title
        case slug
        case featureImage = "feature_image"
        case featured
        case page
        case author
        case authors
        case mobiledoc
        case html
        case plaintext
        case status
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case excerpt = "custom_excerpt"
        case customTemplate = "custom_template"
        case tags
        case metaTitle = "meta_title"
        case metaDescription = "meta_description"
    }
}

extension Card {
    func canBeEditedWithBasicEditor() -> Bool {
        return self is GhostMarkdownCard || self is MarkdownCard
    }
}

extension Story: Decodable {
    init(from decoder: Swift.Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        var mobiledoc: MobileDoc?

        if let mobiledocString = try container.decodeIfPresent(String.self, forKey: .mobiledoc) {
            let jsonMobileDoc = try JSONSerialization.jsonObject(with: mobiledocString.data(using: .utf8)!)
            let mobileDocDecoder = MobileDocDecoder(
                cardsDecoder: CardsDecoder(
                    customCardDecoders: [
                        GhostMarkdownCardDecoder()
                    ]
                )
            )
            mobiledoc = try mobileDocDecoder.decode(fromJSON: (jsonMobileDoc as? [String: Any])!)
        }

        self.init(
            id: try container.decode(String.self, forKey: .id),
            uuid: try container.decode(String.self, forKey: .uuid),
            title: try container.decode(String.self, forKey: .title),
            slug: try container.decodeIfPresent(String.self, forKey: .slug),
            featureImage: try container.decodeIfPresent(String.self, forKey: .featureImage),
            featured: try container.decode(Bool.self, forKey: .featured),
            page: try container.decode(Bool.self, forKey: .page),
            author: try container.decodeIfPresent(Story.Author.self, forKey: .author),
            authors: try container.decodeIfPresent([Story.Author].self, forKey: .authors),
            mobiledoc: mobiledoc,
            html: try container.decodeIfPresent(Story.HTML.self, forKey: .html),
            plaintext: try container.decodeIfPresent(String.self, forKey: .plaintext),
            status: try container.decode(Story.Status.self, forKey: .status),
            excerpt: try container.decodeIfPresent(String.self, forKey: .excerpt),
            customTemplate: try container.decodeIfPresent(String.self, forKey: .customTemplate),
            tags: try container.decode([Tag].self, forKey: .tags),
            updatedAt: try container.decode(Date.self, forKey: .updatedAt),
            publishedAt: try container.decodeIfPresent(Date.self, forKey: .publishedAt),
            metaTitle: try container.decodeIfPresent(String.self, forKey: .metaTitle),
            metaDescription: try container.decodeIfPresent(String.self, forKey: .metaDescription)
        )
    }
}

extension Story: Encodable {

    func encode(to encoder: Swift.Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(uuid, forKey: .uuid)
        try container.encode(title, forKey: .title)
        try container.encode(slug, forKey: .slug)
        try container.encode(featureImage, forKey: .featureImage)
        try container.encode(featured, forKey: .featured)
        try container.encode(page, forKey: .page)
        try container.encode(author, forKey: .author)
        try container.encode(authors, forKey: .authors)
        try container.encode(html, forKey: .html)
        try container.encode(plaintext, forKey: .plaintext)
        try container.encode(status, forKey: .status)
        try container.encode(excerpt, forKey: .excerpt)
        try container.encode(customTemplate, forKey: .customTemplate)
        try container.encode(tags, forKey: .tags)
        try container.encode(updatedAt, forKey: .updatedAt)
        try container.encode(publishedAt, forKey: .publishedAt)
        try container.encode(metaTitle, forKey: .metaTitle)
        try container.encode(metaDescription, forKey: .metaDescription)
        if let mobiledoc = mobiledoc {
            let mobiledocEncoder = MobileDocEncoder()
            let jsonMobileDoc = try mobiledocEncoder.encode(mobiledoc)
            let jsonMobileDocData = try JSONSerialization.data(withJSONObject: jsonMobileDoc)
            let mobiledocString = String(data: jsonMobileDocData, encoding: .utf8)
            try container.encode(mobiledocString, forKey: .mobiledoc)
        }
    }

}

extension Story {
    func getAuthors() -> [Author] {
        if let authors = authors, !authors.isEmpty {
            return authors
        } else if let author = author {
            return [author]
        }
        return []
    }
}

extension Story {
    mutating func publish() {
        status = .published
        self.publishedAt = publishedAt ?? Date()
    }

    mutating func setDraft() {
        status = .draft
    }

    mutating func schedule(forDate date: Date) {
        status = .scheduled
        publishedAt = date
    }
}

extension Story: Equatable {
    // swiftlint:disable:next cyclomatic_complexity
    public static func == (lhs: Story, rhs: Story) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.uuid != rhs.uuid {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.slug != rhs.slug {
            return false
        }
        if lhs.featureImage != rhs.featureImage {
            return false
        }
        if lhs.featured != rhs.featured {
            return false
        }
        if lhs.page != rhs.page {
            return false
        }
        if lhs.author != rhs.author {
            return false
        }
        if lhs.authors != rhs.authors {
            return false
        }
        if lhs.mobiledoc != rhs.mobiledoc {
            return false
        }
        if lhs.html != rhs.html {
            return false
        }
        if lhs.status != rhs.status {
            return false
        }
        if lhs.excerpt != rhs.excerpt {
            return false
        }
        if lhs.updatedAt != rhs.updatedAt {
            return false
        }
        if lhs.publishedAt != rhs.publishedAt {
            return false
        }
        if lhs.metaTitle != rhs.metaTitle {
            return false
        }
        if lhs.metaDescription != rhs.metaDescription {
            return false
        }
        for tag in lhs.tags {
            if !rhs.tags.contains(where: { tagToContain -> Bool in
                return tag == tagToContain
            }) {
                return false
            }
        }
        return true
    }
}

extension Story {
    var isNew: Bool {
        return id.isEmpty
    }
}

extension Story {
    var metaData: MetaData {
        set {
            metaTitle = newValue.title
            metaDescription = newValue.description
        }
        get {
            return MetaData(
                title: metaTitle ?? "",
                description: metaDescription ?? "",
                titleDefault: title,
                descriptionDefault: plaintext
            )
        }
    }
}

extension Story {
    static let searcheableDomain = "stories"
}

struct GhostMarkdownCard: Card {

    static let name: String = "card-markdown"

    var name: String {
        return GhostMarkdownCard.name
    }
    var cardName: String
    var markdown: String
    var payload: [String: Any] {
        return [
            "cardName": cardName,
            "markdown": markdown
        ]
    }

    init(cardName: String = GhostMarkdownCard.name, markdown: String) {
        self.cardName = cardName
        self.markdown = markdown
    }

    func equal(_ rhs: Card) -> Bool {
        guard let card = rhs as? GhostMarkdownCard else {
            return false
        }
        if cardName != card.cardName {
            return false
        }
        if markdown != card.markdown {
            return false
        }
        if !NSDictionary(dictionary: payload).isEqual(to: card.payload) {
            return false
        }
        return true
    }
}

class GhostMarkdownCardDecoder: CardDecoder {

    func decode(_ input: [Any]) -> Card? {
        guard
            input.first as? String == GhostMarkdownCard.name,
            let payload = input.last as? [String: String],
            payload.count == 2,
            let markdown = payload["markdown"],
            let cardName = payload["cardName"]
        else {
                return nil
        }
        return GhostMarkdownCard(cardName: cardName, markdown: markdown)
    }

}
