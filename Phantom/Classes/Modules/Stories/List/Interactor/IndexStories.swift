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

class IndexStories: Interactor<([Story], Account), Any?> {

    private let index: CSSearchableIndex
    private let removeIndexStories: Interactor<Account, Any?>

    init(
        index: CSSearchableIndex = .default(),
        removeIndexStories: Interactor<Account, Any?> = RemoveIndexStories()
    ) {
        self.index = index
        self.removeIndexStories = removeIndexStories
        super.init()
    }

    override func execute(args: ([Story], Account)) -> Result<Any?> {
        var searcheableItems: [CSSearchableItem] = []
        for story in args.0 {
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
            attributeSet.contentModificationDate = story.updatedAt
            attributeSet.completionDate = story.publishedAt
            if let imageSURL = story.featureImage,
                let imageURL = URL(string: imageSURL),
                let data = try? NSData(contentsOf: imageURL) as Data,
                let image = UIImage(data: data) {
                attributeSet.thumbnailData = UIImagePNGRepresentation(image)
            }
            let searchableItem = CSSearchableItem(
                uniqueIdentifier: "\(story.id)~\(args.1.identifier)",
                domainIdentifier: args.1.storyIndexDomain,
                attributeSet: attributeSet
            )
            searcheableItems.append(searchableItem)
        }

        removeIndexStories.execute(args: args.1)
        let semaphore = DispatchSemaphore(value: 0)
        index.indexSearchableItems(searcheableItems, completionHandler: { _ in
            semaphore.signal()
        })
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return .success(nil)
    }
}
