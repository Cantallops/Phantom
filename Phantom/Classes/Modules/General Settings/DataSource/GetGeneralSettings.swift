//
//  GetGeneralSettings.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetGeneralSettings: DataSource<Any?, GeneralSettings> {
    override func execute(args: Any?) -> Result<GeneralSettings> {
        let provider = SettingsAPIProvider()
        let result: Result<GeneralSettings> = Network().call(provider: provider)
        return result
    }
}
