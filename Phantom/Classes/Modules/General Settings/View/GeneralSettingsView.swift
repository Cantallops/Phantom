//
//  GeneralSettingsView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class GeneralSettingsView: TableViewController {

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "General"
        tabBarItem.image = #imageLiteral(resourceName: "ic_table_general_settings")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        navigationItem.title = "General Settings"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    override func setUpTable() {
        super.setUpTable()
        animatedChanges = true
    }
}
