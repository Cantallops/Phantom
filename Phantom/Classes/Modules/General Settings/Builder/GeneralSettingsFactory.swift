//
//  GeneralSettingsBuilder.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class GeneralSettingsBuilder: Builder<Account, UIViewController> {

    override func build(arg: Account) -> UIViewController {
        let presenter = GeneralSettingsPresenter(account: arg)
        let view = GeneralSettingsView(presenter: presenter)
        presenter.view = view
        return view
    }
}
