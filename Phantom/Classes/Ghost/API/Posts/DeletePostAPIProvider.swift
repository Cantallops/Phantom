//
//  DeletePostAPIProvider.swift
//  Phantom
//
//  Created by Alberto Cantallops on 17/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct DeletePostAPIProvider: NetworkProvider {
    let story: Story

    var method: HTTPMethod {
        return .DELETE
    }
    var uri: String {
        return "/posts/\(story.id)/"
    }

    var authenticated: Bool {
        return true
    }
    var contentType: ContentType {
        return .json
    }
}
