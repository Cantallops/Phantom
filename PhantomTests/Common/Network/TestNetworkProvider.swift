//
//  TestNetworkProvider.swift
//  PhantomTests
//
//  Created by Alberto Cantallops on 19/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation
@testable import Phantom

struct TestProvider: NetworkProvider {
    var method: HTTPMethod
    var parameters: [String: Any]
    var baseUrl: String
    var versioning: String?
    var uri: String
    var contentType: ContentType

    init(
        method: HTTPMethod = .GET,
        parameters: [String: Any] = ["param": "1"],
        baseUrl: String = "https://blog.ghost.org",
        versioning: String? = "ghost/api/v0.1",
        uri: String = "test",
        contentType: ContentType = .json
    ) {
        self.method = method
        self.parameters = parameters
        self.baseUrl = baseUrl
        self.versioning = versioning
        self.uri = uri
        self.contentType = contentType
    }

}
