//
//  SignInFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 26/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SignInFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let presenter = SignInPresenter()
        let view = SignInView(presenter: presenter)
        presenter.view = view
        return view
    }
}
