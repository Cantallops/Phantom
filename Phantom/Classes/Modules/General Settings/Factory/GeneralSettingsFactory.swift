//
//  GeneralSettingsFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class GeneralSettingsFactory: Factory<UIViewController> {

    override func build() -> UIViewController {
        let presenter = GeneralSettingsPresenter()
        let view = GeneralSettingsView(presenter: presenter)
        presenter.view = view
        return view
    }
}
