//
//  StoryFilters.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

struct StoryFilters {
    var tagID: String?
    var text: String
}

extension StoryFilters {
    init() {
        text = ""
    }
}
