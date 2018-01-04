//
//  BlogSiteFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class BlogSiteFactory: Factory<UIViewController> {
    override func build() -> ViewController {
        let presenter = BlogSitePresenter()
        let view = BlogSiteView(presenter: presenter)
        presenter.view = view
        return view
    }
}
