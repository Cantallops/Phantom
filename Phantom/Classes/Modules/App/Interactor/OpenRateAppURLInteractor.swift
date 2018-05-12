//
//  OpenRateAppURLInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

enum OpenRateAppURLError: Error {
    case cannotOpen
}

class OpenRateAppURLInteractor: Interactor<Account?, Any?> {

    override func execute(args: Account?) -> Result<Any?> {
        let urlString = "https://itunes.apple.com/app/phantom-editor/id1330804762?ls=1&mt=8&action=write-review"
        guard let url = URL(string: urlString) else {
            return .failure(OpenRateAppURLError.cannotOpen)
        }
        args?.preferences.rateShownDate = Date()
        UIApplication.shared.open(url)
        return .success(nil)
    }
}
