//
//  FilterStories.swift
//  Phantom
//
//  Created by Alberto Cantallops on 25/04/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

class FilterStories: Interactor<([Story], String), [Story]> {

    override func execute(args: ([Story], String)) -> Result<[Story]> {
        return .success(args.0.filter({ story -> Bool in
            return story.title.lowercased().contains(args.1.lowercased()) || args.1.isEmpty
        }))
    }

}
