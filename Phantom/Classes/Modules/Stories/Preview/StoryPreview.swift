//
//  StoryPreview.swift
//  Phantom
//
//  Created by Alberto Cantallops on 29/04/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import Foundation

class StoryPreview: WebViewController {
    func load(story: Story) {
        title = "Preview"
        load(url: URL(string: "\(Account.current!.blogUrl)p/\(story.uuid)/")!)
    }
}
