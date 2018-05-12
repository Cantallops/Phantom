//
//  OpenRateAppNativeInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation
import StoreKit

enum OpenRateAppNativeError: Error {
    case cannotShown
    case notSupported
}

class OpenRateAppNativeInteractor: Interactor<Account, Any?> {

    override func execute(args: Account) -> Result<Any?> {
        let lastShownDate = args.preferences.rateShownDate
        let now = Date()

        let days = now.daysPassed(date: lastShownDate)
        guard days > 3 else {
            return .failure(OpenRateAppNativeError.cannotShown)
        }
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
            args.preferences.rateShownDate = now
            return .success(nil)
        }
        return .failure(OpenRateAppNativeError.notSupported)
    }
}
