//
//  AppSettingsPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 15/05/2018.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AppSettingsPresenter: Presenter<AppSettingsView> {

    private var preferences: Preferences

    init(
        preferences: Preferences
    ) {
        self.preferences = preferences
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
        let header = SimpleTableSectionHeaderConf(title: "Spotlight")
        let footer = SimpleTableSectionFooterConf(
            title: "Allow the app to index all your post to search them inside spotlight"
        )
        return UITableView.Section(id: "Spotlight", header: header, cells: [indexStoriesCell], footer: footer)
    }

    private func getEditorSettingsSection() -> UITableView.Section {
        let spellCheckingCell = SwitchTableViewCell.Conf(text: "Check Spelling", onSwitch: { [weak self] bool in
            self?.preferences.spellChecking = bool
        }, isOn: preferences.spellChecking)
        let autocorrectionCell = SwitchTableViewCell.Conf(text: "Auto-Correction", onSwitch: { [weak self] bool in
            self?.preferences.autocorrection = bool
        }, isOn: preferences.autocorrection)
        let autocapitalizationCell = SwitchTableViewCell.Conf(
            text: "Auto-Capitalization",
            onSwitch: { [weak self] bool in
                self?.preferences.autocapitalization = bool
            },
            isOn: preferences.autocapitalization
        )
        let cells = [spellCheckingCell, autocorrectionCell, autocapitalizationCell]
        let header = SimpleTableSectionHeaderConf(title: "Editor settings")
        let footer = SimpleTableSectionFooterConf(
            title: "These settings does not override your system settings. Settings > General > Keyboard"
        )
        return UITableView.Section(id: "EditorSettings", header: header, cells: cells, footer: footer)
    }
}
