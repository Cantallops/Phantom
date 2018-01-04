//
//  GetGeneralSettings.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct SettingsProvider: NetworkProvider {
    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/settings/"
    }
    var authenticated: Bool {
        return true
    }
}

class GetGeneralSettings: DataSource<Any?, GeneralSettings> {
    override func execute(args: Any?) -> Result<GeneralSettings> {
        let provider = SettingsProvider()
        let result: Result<GeneralSettings> = Network(provider: provider).call()
        return result
    }
}
