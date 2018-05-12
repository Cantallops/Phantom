//
//  MoreFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class MoreFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let presenter = MorePresenter(account: .current)
        let view = MoreView(presenter: presenter)
        presenter.view = view
        return view
    }
}
