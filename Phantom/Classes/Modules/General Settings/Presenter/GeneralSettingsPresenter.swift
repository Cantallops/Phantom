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
    private var preferences: Preferences {
        return account.preferences
    }

    init(
        account: Account
    ) {
        self.account = account
        super.init()
    }

    override func willAppear() {
        super.willAppear()
        loadSettings()
    }

    private func loadSettings() {
        view.sections = [
            getEditorSettingsSection(),
            getAppSettingsSection()
        ]
    }

    private func getAppSettingsSection() -> UITableView.Section {
        let indexStoriesCell = SwitchTableViewCell.Conf(text: "Index posts", onSwitch: { [weak self] bool in
            self?.preferences.indexStories = bool
        }, isOn: preferences.indexStories)
        let header = SimpleTableSectionHeader(title: "App settings")
        let footer = EmptyTableSectionFooter(height: 20)
        return UITableView.Section(id: "AppSettings", header: header, cells: [indexStoriesCell], footer: footer)
    }

    private func getEditorSettingsSection() -> UITableView.Section {
        let spellCheckingCell = SwitchTableViewCell.Conf(text: "Spell Checking", onSwitch: { [weak self] bool in
            self?.preferences.spellChecking = bool
        }, isOn: preferences.spellChecking)
        let autocorrectionCell = SwitchTableViewCell.Conf(text: "Autocorrection", onSwitch: { [weak self] bool in
            self?.preferences.autocorrection = bool
        }, isOn: preferences.autocorrection)
        let cells = [spellCheckingCell, autocorrectionCell]
        let header = SimpleTableSectionHeader(title: "Editor settings")
        let footer = SimpleTableSectionFooter(title: "These settings does not override your system settings. Settings > General > Keyboard")
        return UITableView.Section(id: "EditorSettings", header: header, cells: cells, footer: footer)
    }
}
