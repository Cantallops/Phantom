//
//  BrowseThemeAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct BrowseThemeAPIProvider: NetworkProvider {
    var method: HTTPMethod {
        return .GET
    }

    var uri: String {
        return "/themes/"
    }

    var authenticated: Bool {
        return true
    }
}
