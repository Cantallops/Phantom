//
//  TeamListFactory.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TeamListFactory: Factory<UIViewController> {
    override func build() -> UIViewController {
        let presenter = TeamListPresenter()
        let view = TeamListView(presenter: presenter)
        presenter.view = view
        return view
    }
}
