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
    var favIconURL: URL? {
        return URL(string: "\(blogUrl)favicon.png")
    }
}
