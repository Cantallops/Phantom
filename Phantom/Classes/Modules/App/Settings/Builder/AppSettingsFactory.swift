//
//  AppSettingsBuilder.swift
//  Phantom
//
//  Created by Alberto Cantallops on 15/05/2018.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AppSettingsBuilder: Builder<Preferences, UIViewController> {

    override func build(arg: Preferences) -> UIViewController {
        let presenter = AppSettingsPresenter(preferences: arg)
        let view = AppSettingsView(presenter: presenter)
        presenter.view = view
        return view
    }
}
