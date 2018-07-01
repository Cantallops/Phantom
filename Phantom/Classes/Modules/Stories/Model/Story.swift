//
//  Story.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct Story: Codable {
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

    typealias MobileDoc = String
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
            if let data = mobiledoc?.data(using: .utf8),
                let anyJson = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = anyJson as? JSON,
                let cards = json["cards"] as? [[Any]],
                let firstCard = cards.first,
                let cardMarkdown = firstCard.last as? JSON,
                let markdownFromMobileDoc = cardMarkdown["markdown"] as? String {
                    return markdownFromMobileDoc
            }
            if let html = html {
                return html
            }
            return plaintext ?? ""
        }
        set {
            mobiledoc = MobileDoc.get(from: newValue)
        }
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

extension Story.MobileDoc {
    static func get(from markdown: Story.Markdown) -> Story.MobileDoc {
        let scapedMarkdown = markdown
            .replacing("\\", "\\\\")
            .replacing("\"", "\\\"")      // replace " with \"
            .replacing("\n", "\\n")       // replace new line with \n
            .replacing("\t", "\\t")       // replace tab with \t
            .replacing("\r", "\\r")       // replace carriage return with \r
        return """
                {
                    "version":"0.3.1",
                    "markups":[],
                    "atoms":[],
                    "cards":[
                        ["card-markdown", {
                            "cardName":"card-markdown",
                            "markdown":"\(scapedMarkdown)"
                        }]
                    ],
                    "sections":[[10,0]]
                }
               """
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
