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

class FilterStories: Interactor<([Story], StoryFilters), [Story]> {
    override func execute(args: ([Story], StoryFilters)) -> Result<[Story]> {
        var stories = args.0.search(text: args.1.text)
        stories = stories.filter { story -> Bool in
            return story.tags.contains(where: { tag -> Bool in
                guard let tagID = args.1.tagID else {
                    return true
                }
                return tag.id == tagID
            })
        }
        return .success(stories)
    }
}
