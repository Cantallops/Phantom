//
//  RemoveIndexStoryInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 10/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

import Foundation
import CoreSpotlight

class RemoveIndexStoryInteractor: Interactor<(Story, Account), Any?> {
    private let index: CSSearchableIndex

    init(
        index: CSSearchableIndex = .default()
    ) {
        self.index = index
        super.init()
    }

    override func execute(args: (Story, Account)) -> Result<Any?> {
        let semaphore = DispatchSemaphore(value: 0)
        index.deleteSearchableItems(withIdentifiers: [args.0.searcheableIdentifier(forAccount: args.1)]) { _ in
            semaphore.signal()
        }
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return .success(nil)
    }
}
