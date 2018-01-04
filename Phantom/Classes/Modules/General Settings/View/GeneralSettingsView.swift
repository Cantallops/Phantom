//
//  GeneralSettingsView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class GeneralSettingsView: ViewController {

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "General"
        tabBarItem.image = #imageLiteral(resourceName: "ic_table_general_settings")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        navigationItem.title = "General Settings"
        navigationItem.largeTitleDisplayMode = .never
    }

}
