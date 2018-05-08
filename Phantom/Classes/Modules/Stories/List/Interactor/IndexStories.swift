//
//  IndexStories.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class IndexStories: Interactor<[Story], Any?> {
    override func execute(args: [Story]) -> Result<Any?> {
        let domainIdentifier = "stories"
        var searcheableItems: [CSSearchableItem] = []
        for story in args {
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
            attributeSet.title = story.title
            var authors: [String] = []
            if let author = story.author?.name {
                authors = [author]
            }
            attributeSet.authorNames = authors
            attributeSet.contentDescription = story.excerpt ?? story.plaintext
            attributeSet.keywords = story.tags.compactMap({ tag -> String? in
                return tag.name
            })
            if let imageSURL = story.featureImage,
                let imageURL = URL(string: imageSURL),
                let data = try? NSData(contentsOf: imageURL) as Data,
                let image = UIImage(data: data) {
                attributeSet.thumbnailData = UIImagePNGRepresentation(image)
            }
            let searchableItem = CSSearchableItem(
                uniqueIdentifier: story.id,
                domainIdentifier: domainIdentifier,
                attributeSet: attributeSet
            )
            searcheableItems.append(searchableItem)
        }
        let index = CSSearchableIndex.default()
        index.deleteSearchableItems(withDomainIdentifiers: [domainIdentifier]) { _ in
            index.indexSearchableItems(searcheableItems, completionHandler: nil)
        }
        return .success(nil)
    }
}
