//
//  BlogConfiguration.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct BlogConfiguration: Codable {
    let blogUrl: String
    let blogTitle: String
    let clientId: String
    let clientSecret: String

}

extension BlogConfiguration {
    var favIconURL: URL? {
        var url = URL(string: blogUrl)
        url?.appendPathComponent("favicon.png")
        return url
    }
}
