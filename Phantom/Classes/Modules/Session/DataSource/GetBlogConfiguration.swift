//
//  GetBlogConfiguration.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

private struct BlogConfigurationApi: Codable {
    var configuration: [BlogConfiguration]
}

class GetBlogConfiguration: DataSource<(String, String), BlogConfiguration> {
    override func execute(args: (String, String)) -> Result<BlogConfiguration> {
        let provider = ConfigurationAPIProvider(baseUrl: args.0, versioning: args.1)
        let result: Result<BlogConfigurationApi> = Network().call(provider: provider)
        switch result {
        case .success(let blogConfigurationApi):
            guard let blogConfiguration = blogConfigurationApi.configuration.first else {
                let error = NetworkError(kind: .unknown, debugDescription: "No configuration found")
                return .failure(error)
            }
            return .success(blogConfiguration)
        case .failure(let error):
            return .failure(error)
        }
    }
}
