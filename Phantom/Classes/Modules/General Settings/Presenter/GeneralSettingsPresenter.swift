//
//  GeneralSettingsPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class GeneralSettingsPresenter: Presenter<GeneralSettingsView> {

    private let account: Account

    init(
        account: Account
    ) {
        self.account = account
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        view.sections = [
            getAppSettingsSection()
        ]
    }

    private func getAppSettingsSection() -> UITableView.Section {
        let indexStoriesCell = SwitchTableViewCell.Conf(text: "Index posts", image: nil, onSwitch: { [weak self] bool in
            self?.account.preferences.indexStories = bool
        }, isOn: account.preferences.indexStories)
        let header = SimpleTableSectionHeader(title: "App settings")
        return UITableView.Section(id: "AppSettings", header: header, cells: [indexStoriesCell])
    }
}
