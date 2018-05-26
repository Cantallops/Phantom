//
//  GetCurrentTemplatesInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetCurrentTemplatesInteractor: Interactor<Any?, [Theme.Template]> {

    private let getThemes: DataSource<Any?, [Theme]>

    init(
        getThemes: DataSource<Any?, [Theme]> = GetThemes()
    ) {
        self.getThemes = getThemes
        super.init()
    }

    override func execute(args: Any?) -> Result<[Theme.Template]> {
        let themesResult = getThemes.execute(args: nil)
        switch themesResult {
        case .success(let themes):
            return .success(themes.first(where: { $0.active })?.templates ?? [])
        case .failure(let error):
            return .failure(error)
        }
    }
}
