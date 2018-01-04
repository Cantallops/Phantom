//
//  ClientKeys.swift
//  Phantom
//
//  Created by Alberto Cantallops on 27/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

struct ClientKeys: Codable {
    let secret: String
    let id: String
}

extension BlogConfiguration {
    var clientKeys: ClientKeys {
        return ClientKeys(secret: clientSecret, id: clientId)
    }
}
