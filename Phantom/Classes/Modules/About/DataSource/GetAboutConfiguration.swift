//
//  GetAboutConfiguration.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct AboutConfigurationApi: Codable {
    var configuration: [AboutGhost]
}

class GetAboutConfiguration: DataSource<Any?, AboutGhost> {
    override func execute(args: Any?) -> Result<AboutGhost> {
        let provider = AboutConfigurationAPIProvider()
        let result: Result<AboutConfigurationApi> = Network().call(provider: provider)
        switch result {
        case .success(let aboutConfigurationApi):
            guard let aboutConfiguration = aboutConfigurationApi.configuration.first else {
                let error = NetworkError(kind: .unknown, debugDescription: "No configuration found")
                return .failure(error)
            }
            return .success(aboutConfiguration)
        case .failure(let error):
            return .failure(error)
        }
    }
}
