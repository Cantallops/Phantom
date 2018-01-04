//
//  DetectGhostInstallation.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class DetectGhostInstallation: Interactor<URL, String> {

    private let blogConfigurationDataSource: DataSource<(String, String), BlogConfiguration>

    init(
        blogConfigurationDataSource: DataSource<(String, String), BlogConfiguration> = GetBlogConfiguration()
    ) {
        self.blogConfigurationDataSource = blogConfigurationDataSource
        super.init()
    }

    override func execute(args: URL) -> Result<String> {
        let versioning = "ghost/api/v0.1"
        let dataSourceArgs = (args.absoluteStringWithHttp, versioning)
        let configuration = blogConfigurationDataSource.execute(args: dataSourceArgs)
        switch configuration {
        case .success(let configuration):
            var username = ""
            if let lastAccount = Account.last, configuration.blogUrl == lastAccount.blogUrl {
                username = lastAccount.username
            }
            Account.current = Account(
                blogUrl: configuration.blogUrl,
                apiVersion: versioning,
                username: username,
                clientKeys: configuration.clientKeys,
                oauth: nil
            )
            return .success(configuration.blogTitle)
        case .failure(let error):
            return .failure(error)
        }
    }
}
