//
//  GetThemes.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetThemes: DataSource<Any?, [Theme]> {

    struct APIThemes: Codable {
        let themes: [Theme]
    }

    override func execute(args: Any?) -> Result<[Theme]> {
        let provider = BrowseThemeAPIProvider()
        let result: Result<APIThemes> = Network().call(provider: provider)
        switch result {
        case .success(let apiTheme):
            return .success(apiTheme.themes)
        case .failure(let error):
            return .failure(error)
        }
    }
}
