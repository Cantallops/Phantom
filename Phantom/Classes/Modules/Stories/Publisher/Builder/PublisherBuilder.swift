//
//  PublisherBuilder.swift
//  Phantom
//
//  Created by Alberto Cantallops on 13/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import PopupDialog

typealias PublisherArg = (Story, OnPublishAction)

class PublisherBuilder: Builder<PublisherArg, UIViewController> {
    override func build(arg: PublisherArg) -> UIViewController {
        let presenter = PublisherPresenter(story: arg.0, onPublishAction: arg.1)
        let view = PublisherView(presenter: presenter)
        presenter.view = view

        let popup = PopupDialog(
            viewController: view,
            transitionStyle: .zoomIn,
            gestureDismissal: true
        )
        return popup
    }
}
