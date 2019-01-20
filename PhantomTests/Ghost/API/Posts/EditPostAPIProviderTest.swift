//
//  EditPostAPIProviderTest.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 20/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import XCTest
@testable import Phantom

class EditPostAPIProviderTest: XCTestCase {

    var provider: NetworkProvider!
    var post: Story = .any

    override func setUp() {
        super.setUp()
        provider = EditPostAPIProvider(story: post)
    }

    func testMethod() {
        XCTAssertEqual(provider.method, .PUT)
    }

    func testUri() {
        XCTAssertEqual(provider.uri, "/posts/\(post.id)/")
    }

    func testAuthenticated() {
        XCTAssertTrue(provider.authenticated)
    }

    func testContentType() {
        XCTAssertEqual(provider.contentType, .json)
    }

    func testParams() {
        let posts = (provider.parameters["posts"]! as? [JSON])!
        let postJSON = posts.first!
        let authorJSON = (postJSON["authors"] as? [JSON])!.first!
        let tagJSON = (postJSON["tags"] as? [JSON])!.first!

        XCTAssertEqual(postJSON["title"] as? String, post.title)
        XCTAssertEqual(postJSON["featured"] as? Bool, post.featured)
        XCTAssertEqual(postJSON["feature_image"] as? String, post.featureImage)
        XCTAssertEqual(postJSON["page"] as? Bool, post.page)
        XCTAssertEqual(postJSON["featured"] as? Bool, post.featured)
        XCTAssertEqual(postJSON["slug"] as? String, post.slug)
        XCTAssertEqual(postJSON["status"] as? String, post.status.rawValue)
        XCTAssertEqual(postJSON["published_at"] as? String, post.publishedAt?.apiFormated())
        XCTAssertEqual(postJSON["custom_excerpt"] as? String, post.excerpt)
        XCTAssertEqual(postJSON["meta_title"] as? String, post.metaTitle)
        XCTAssertEqual(postJSON["meta_description"] as? String, post.metaDescription)
        XCTAssertEqual(postJSON["custom_template"] as? String, post.customTemplate)
        XCTAssertEqual(authorJSON["id"] as? String, post.getAuthors().first?.id)
        XCTAssertEqual(authorJSON["name"] as? String, post.getAuthors().first?.name)
        XCTAssertEqual(tagJSON["id"] as? String, post.tags.first?.id)
        XCTAssertEqual(tagJSON["name"] as? String, post.tags.first?.name)
    }

    func testQueryParams() {
        let params = provider.queryParameters
        XCTAssertEqual(params["include"] as? String, "author,authors,tags")
        XCTAssertEqual(params["formats"] as? String, "mobiledoc,html")
    }

}
