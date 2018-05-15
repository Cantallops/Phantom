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
        let header = SimpleTableSectionHeader(title: "Spotlight")
        let footer = SimpleTableSectionFooter(
            title: "Allow the app to index all your post to search them inside spotlight"
        )
        return UITableView.Section(id: "Spotlight", header: header, cells: [indexStoriesCell], footer: footer)
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
        let footer = SimpleTableSectionFooter(
            title: "These settings does not override your system settings. Settings > General > Keyboard"
        )
        return UITableView.Section(id: "EditorSettings", header: header, cells: cells, footer: footer)
    }
}
