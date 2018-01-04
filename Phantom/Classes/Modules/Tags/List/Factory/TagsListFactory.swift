//
//  TagsListFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TagsListFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let presenter = TagsListPresenter(
            tagInternalNotificationCenter: tagInternalNotificationCenter
        )
        let view = TagsListView(presenter: presenter)
        presenter.view = view
        return view
    }
}
