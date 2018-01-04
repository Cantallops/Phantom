//
//  StorySettingsView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class StorySettingsView: TableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
    }

    override func setUpTable() {
        super.setUpTable()
        tableView.backgroundColor = Color.lighterGrey
    }
}
