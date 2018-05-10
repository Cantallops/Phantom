//
//  GetAboutGhostConfigurationInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetAboutGhostConfigurationInteractor: Interactor<Any?, AboutGhost> {
    private let getAboutConfiguration: DataSource<Any?, AboutGhost>

    init(
        getAboutConfiguration: DataSource<Any?, AboutGhost> = GetAboutConfiguration()
    ) {
        self.getAboutConfiguration = getAboutConfiguration
    }

    override func execute(args: Any?) -> Result<AboutGhost> {
        return getAboutConfiguration.execute(args: args)
    }
}
