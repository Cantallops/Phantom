//
//  AboutFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 23/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AboutFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let presenter = AboutPresenter()
        let view = AboutView(presenter: presenter)
        presenter.view = view
        return view
    }
}
