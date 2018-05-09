//
//  RemoveIndexStories.swift
//  Phantom
//
//  Created by Alberto Cantallops on 09/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation
import CoreSpotlight

class RemoveIndexStories: Interactor<Account, Any?> {
    private let index: CSSearchableIndex

    init(
        index: CSSearchableIndex = .default()
    ) {
        self.index = index
        super.init()
    }

    override func execute(args: Account) -> Result<Any?> {
        let semaphore = DispatchSemaphore(value: 0)
        index.deleteSearchableItems(withDomainIdentifiers: [args.storyIndexDomain]) { _ in
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return .success(nil)
    }
}
