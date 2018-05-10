//
//  IndexStoryInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 10/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

import UIKit
import CoreSpotlight
import MobileCoreServices

class IndexStoryInteractor: Interactor<(Story, Account), Any?> {
    private let index: CSSearchableIndex
    private let removeIndexStory: Interactor<(Story, Account), Any?>

    init(
        index: CSSearchableIndex = .default(),
        removeIndexStory: Interactor<(Story, Account), Any?> = RemoveIndexStoryInteractor()
       ) {
        self.index = index
        self.removeIndexStory = removeIndexStory
        super.init()
    }

    override func execute(args: (Story, Account)) -> Result<Any?> {
        let story = args.0
        let searcheableItem = story.searcheableItem(forAccount: args.1)

        removeIndexStory.execute(args: args)
        let semaphore = DispatchSemaphore(value: 0)
        index.indexSearchableItems([searcheableItem], completionHandler: { _ in
            semaphore.signal()
        })
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return .success(nil)
    }
}

extension Story {

    func searcheableIdentifier(forAccount account: Account) -> String {
        return "\(id)~\(account.identifier)"
    }

    func searcheableItem(forAccount account: Account) -> CSSearchableItem {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeData as String)
        attributeSet.title = title
        var authors: [String] = []
        if let author = author?.name {
            authors = [author]
        }
        attributeSet.authorNames = authors
        attributeSet.contentDescription = excerpt ?? plaintext
        attributeSet.keywords = tags.compactMap({ tag -> String? in
            return tag.name
        })
        attributeSet.contentModificationDate = updatedAt
        attributeSet.completionDate = publishedAt
        if let imageSURL = featureImage,
            let imageURL = URL(string: imageSURL),
            let data = try? NSData(contentsOf: imageURL) as Data,
            let image = UIImage(data: data) {
            attributeSet.thumbnailData = UIImagePNGRepresentation(image)
        }
        return CSSearchableItem(
            uniqueIdentifier: searcheableIdentifier(forAccount: account),
            domainIdentifier: account.storyIndexDomain,
            attributeSet: attributeSet
        )
    }
}
