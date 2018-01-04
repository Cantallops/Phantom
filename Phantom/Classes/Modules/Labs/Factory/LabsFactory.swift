//
//  LabsFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class LabsFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let presenter = LabsPresenter()
        let view = LabsView(presenter: presenter)
        presenter.view = view
        return view
    }
}
