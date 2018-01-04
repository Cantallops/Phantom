//
//  StoriesListFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class StoriesListFactory: Factory<UIViewController> {

    override func build() -> UIViewController {
        let presenter = StoriesListPresenter(
            storyInternalNotificationCenter: storyInternalNotificationCenter,
            tagInternalNotificationCenter: tagInternalNotificationCenter
        )
        let view = StoriesListView(presenter: presenter)
        presenter.view = view
        return view
    }
}
