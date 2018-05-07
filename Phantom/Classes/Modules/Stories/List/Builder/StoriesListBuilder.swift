//
//  StoriesListBuilder.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/05/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class StoriesListBuilder: Builder<StoryFilters?, UIViewController> {
    override func build(arg: StoryFilters?) -> UIViewController {
        let presenter = StoriesListPresenter(
            storyInternalNotificationCenter: storyInternalNotificationCenter,
            tagInternalNotificationCenter: tagInternalNotificationCenter
        )
        let view = StoriesListView(presenter: presenter)
        presenter.view = view
        if let filters = arg {
            presenter.filter(by: filters)
        }
        return view
    }
}
