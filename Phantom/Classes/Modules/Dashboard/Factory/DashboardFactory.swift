//
//  DashboardFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class DashboardFactory: Factory<UIViewController> {

    private let device: UIDevice

    init(device: UIDevice = .current) {
        self.device = device
        super.init()
    }

    override func build() -> UIViewController {
        if device.isPad {
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
