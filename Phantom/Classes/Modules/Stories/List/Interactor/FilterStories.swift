//
//  FilterStories.swift
//  Phantom
//
//  Created by Alberto Cantallops on 25/04/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

extension Story: Searcheable {
    func searchTerms() -> [String] {
        return [self.title]
    }
}

class FilterStories: Interactor<([Story], String), [Story]> {
    override func execute(args: ([Story], String)) -> Result<[Story]> {
        let stories = args.0.search(text: args.1)
        return .success(stories)
    }
}
