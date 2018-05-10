//
//  IndexStoriesInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

class IndexStoriesInteractor: Interactor<([Story], Account), Any?> {

    private let index: CSSearchableIndex
    private let removeIndexStories: Interactor<Account, Any?>

    init(
        index: CSSearchableIndex = .default(),
        removeIndexStories: Interactor<Account, Any?> = RemoveIndexStoriesInteractor()
    ) {
        self.index = index
        self.removeIndexStories = removeIndexStories
        super.init()
    }

    override func execute(args: ([Story], Account)) -> Result<Any?> {
        var searcheableItems: [CSSearchableItem] = []
        for story in args.0 {
            let searchableItem = story.searcheableItem(forAccount: args.1)
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
