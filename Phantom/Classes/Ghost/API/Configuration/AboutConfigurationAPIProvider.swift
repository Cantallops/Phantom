//
//  AboutConfigurationAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct AboutConfigurationAPIProvider: NetworkProvider {
    var method: HTTPMethod {
        return .GET
    }
    var uri: String {
        return "/configuration/about/"
    }
    var authenticated: Bool {
        return true
    }
}
