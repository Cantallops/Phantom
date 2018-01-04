//
//  DashboardFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class DashboardFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let presenter = DashboardPresenter()
        let view = DashboardView(presenter: presenter)
        presenter.view = view
        return view
    }
}
