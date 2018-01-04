//
//  SessionFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit
import PopupDialog

class SessionFactory: Factory<UIViewController> {

    override func build() -> UIViewController {
        let blogSite = BlogSiteFactory().build()
        let nav = NavigationController(rootViewController: blogSite)
        nav.view.translatesAutoresizingMaskIntoConstraints = false
        nav.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        let popup = PopupDialog(viewController: nav, transitionStyle: .fadeIn, gestureDismissal: false)
        return popup
    }

}
