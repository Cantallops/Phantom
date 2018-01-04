//
//  AppsView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AppsView: ViewController {

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "Apps"
        tabBarItem.image = #imageLiteral(resourceName: "ic_table_apps")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        navigationItem.title = "Apps"
        navigationItem.largeTitleDisplayMode = .never
    }
}
