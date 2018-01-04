//
//  MorePresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class MorePresenter: Presenter<MoreView> {
    private var settings: [UIViewController] = [] {
        didSet {
            loadSections(withSettings: settings)
        }
    }

    private let doSignOutInteractor: Interactor<Any?, Any?>
    private let getSettingsSection: Interactor<Any?, [UIViewController]>
    private let aboutFactory: Factory<UIViewController>

    init(
        doSignOutInteractor: Interactor<Any?, Any?> = DoSignOut(),
        getSettingsSection: Interactor<Any?, [UIViewController]> = GetSettingsSections(),
        aboutFactory: Factory<UIViewController> = AboutFactory()
    ) {
        self.doSignOutInteractor = doSignOutInteractor
        self.getSettingsSection = getSettingsSection
        self.aboutFactory = aboutFactory
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        loadSections()
        loadSettingsSection()
    }

    fileprivate func loadSections(withSettings settings: [UIViewController] = []) {
        var sections: [UITableView.Section] = []
        if !settings.isEmpty {
            sections.append(getSettingSection(from: settings))
        }
        sections.append(getInfoSection())
        sections.append(getLogOutSection())
        view.sections = sections
    }

    fileprivate func getSettingSection(from settings: [UIViewController]) -> UITableView.Section {
        var cells: [TableCellConf] = []
        for setting in settings {
            let conf = BasicTableViewCell.Conf(
                text: setting.title,
                image: setting.tabBarItem.image
            )
            conf.deselect = true
            conf.accessoryType = .disclosureIndicator
            conf.onSelect = { [weak self] in
                self?.open(viewController: setting)
            }
            cells.append(conf)
        }
        var section = UITableView.Section(cells: cells)
        section.header = SimpleTableSectionHeader(title: "Settings")
        section.footer = EmptyTableSectionFooter(height: 20)
        return section
    }

    fileprivate func loadSettingsSection() {
        async(background: { [unowned self] in
            return self.getSettingsSection.execute(args: nil)
        }, main: { [weak self] result in
                switch result {
                case .success(let settings):
                    self?.settings = settings
                case .failure(let error):
                    self?.show(error: error)
                }
        })
    }

    fileprivate func getInfoSection() -> UITableView.Section {
        let conf = BasicTableViewCell.Conf(
            text: "About",
            image: #imageLiteral(resourceName: "ic_table_info")
        )
        conf.deselect = true
        conf.accessoryType = .disclosureIndicator
        conf.onSelect = { [weak self] in
            self?.openInfo()
        }
        var section = UITableView.Section(cells: [conf])
        section.header = EmptyTableSectionHeader(height: 20)
        section.footer = EmptyTableSectionFooter(height: 20)
        return section
    }

    fileprivate func getLogOutSection() -> UITableView.Section {
        let conf = BasicTableViewCell.Conf(
            text: "Sign Out",
            image: #imageLiteral(resourceName: "ic_table_signout")
        )
        conf.deselect = true
        conf.onSelect = { [weak self] in
            self?.signOut()
        }
        var section = UITableView.Section(cells: [conf])
        section.header = EmptyTableSectionHeader(height: 20)
        section.footer = EmptyTableSectionFooter(height: 20)
        return section
    }

    private func openInfo() {
        let aboutView = aboutFactory.build()
        open(viewController: aboutView)
    }

    private func open(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        view.navigationController?.pushViewController(viewController, animated: true)
    }

    private func signOut() {
        async(background: { [weak self] in
            return self?.doSignOutInteractor.execute(args: nil)
        })
    }
}
