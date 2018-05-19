//
//  Network.swift
//  Phantom
//
//  Created by Alberto Cantallops on 19/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

enum HTTPMethod: String {
    case POST
    case GET
    case PUT
    case DELETE
}

enum ContentType: String {
    case formURLEncoded = "application/x-www-form-urlencoded"
    case json = "application/json"
    case multipart = "multipart/form-data"
}

class Network {

    var refreshOauth: DataSource<Oauth, Oauth>

    init(
        refreshOauth: DataSource<Oauth, Oauth> = RefreshOauth()
    ) {
        self.refreshOauth = refreshOauth
    }
}
