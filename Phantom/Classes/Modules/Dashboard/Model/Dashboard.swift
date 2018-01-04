//
//  Dashboard.swift
//  Phantom
//
//  Created by Alberto Cantallops on 12/11/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

struct Dashboard {

    struct Section {
        var kind: Kind
        var name: String
        var icon: UIImage
        var selectedIcon: UIImage?
        var factory: Factory<UIViewController>
        var nav: Bool

        init(
            kind: Kind,
            name: String,
            icon: UIImage,
            selectedIcon: UIImage? = nil,
            factory: Factory<UIViewController>,
            nav: Bool
        ) {
            self.kind = kind
            self.name = name
            self.icon = icon
            self.selectedIcon = selectedIcon
            self.factory = factory
            self.nav = nav
        }

        enum Kind {
            case story
            case team
            case subscribers
            case more
        }
    }

}
