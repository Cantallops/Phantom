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
        if UIDevice.current.userInterfaceIdiom == .pad {
           return padBuild()
        }
        return phoneBuild()
    }

    private func phoneBuild() -> UIViewController {
        let presenter = DashboardPresenter()
        let view = DashboardView(presenter: presenter)
        presenter.view = view
        return view
    }

    private func padBuild() -> UIViewController {
        let presenter = TabletDashboardPresenter()
        let view = TabletDashboardView(presenter: presenter)
        presenter.view = view
        return view
    }
}
