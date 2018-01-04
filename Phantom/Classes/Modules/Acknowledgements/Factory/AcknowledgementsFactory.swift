//
//  AcknowledgementsFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AcknowledgementsFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let presenter = AcknowledgementsPresenter()
        let view = AcknowledgementsView(presenter: presenter)
        presenter.view = view
        return view
    }
}
