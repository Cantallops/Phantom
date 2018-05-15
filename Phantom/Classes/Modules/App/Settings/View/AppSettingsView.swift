//
//  AppSettingsView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 15/05/2018.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AppSettingsView: TableViewController {

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "App Settings"
        tabBarItem.image = #imageLiteral(resourceName: "ic_table_app_settings")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        navigationItem.title = "App Settings"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    override func setUpTable() {
        super.setUpTable()
        animatedChanges = true
    }
}
