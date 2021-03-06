//
//  MorePresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class MorePresenter: Presenter<MoreView> {
    private var blogInfo: BlogInfo? {
        didSet {
            loadSections(withSettings: settings, andBlogInfo: blogInfo)
        }
    }
    private var settings: [UIViewController] = [] {
        didSet {
            loadSections(withSettings: settings, andBlogInfo: blogInfo)
        }
    }

    private let worker: Worker
    private let account: Account?
    private let doSignOutInteractor: Interactor<Any?, Any?>
    private let getCurrentBlogInfo: Interactor<Any?, BlogInfo>
    private let getFavIconImage: Interactor<Any?, UIImage>
    private let getSettingsSection: Interactor<Any?, [UIViewController]>
    private let aboutFactory: Factory<UIViewController>
    private let openRateAppURLInteractor: Interactor<Account?, Any?>

    init(
        worker: Worker = AsyncWorker(),
        account: Account?,
        doSignOutInteractor: Interactor<Any?, Any?> = DoSignOutInteractor(),
        getCurrentBlogInfo: Interactor<Any?, BlogInfo> = GetCurrentBlogInfoInteractor(),
        getFavIconImage: Interactor<Any?, UIImage> = GetFavIconImageInteractor(),
        getSettingsSection: Interactor<Any?, [UIViewController]> = GetSettingsSections(),
        aboutFactory: Factory<UIViewController> = AboutFactory(),
        openRateAppURLInteractor: Interactor<Account?, Any?> = OpenRateAppURLInteractor()
    ) {
        self.worker = worker
        self.account = account
        self.doSignOutInteractor = doSignOutInteractor
        self.getCurrentBlogInfo = getCurrentBlogInfo
        self.getFavIconImage = getFavIconImage
        self.getSettingsSection = getSettingsSection
        self.aboutFactory = aboutFactory
        self.openRateAppURLInteractor = openRateAppURLInteractor
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        loadSections()
        loadMe()
        loadSettingsSection()
    }

    fileprivate func loadSections(
        withSettings settings: [UIViewController] = [],
        andBlogInfo blogInfo: BlogInfo? = nil
    ) {
        var sections: [UITableView.Section] = []
        if let blogInfo = blogInfo {
            sections.append(getBlogInfoSection(using: blogInfo))
        }
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
        var section = UITableView.Section(id: "Settings", cells: cells)
        section.header = SimpleTableSectionHeaderConf(title: "Settings")
        section.footer = EmptyTableSectionFooterConf(height: 20)
        return section
    }

    fileprivate func loadMe() {
        let task = Task(qos: .userInitiated, task: { [unowned self] in
            return self.getCurrentBlogInfo.execute(args: nil)
        }, completion: { [weak self] result in
            switch result {
            case .success(let blogInfo):
                self?.blogInfo = blogInfo
            case .failure(let error):
                self?.show(error: error)
            }
        })
        worker.execute(task: task)
    }
    fileprivate func loadSettingsSection() {
        let task = Task(qos: .userInitiated, task: { [unowned self] in
            return self.getSettingsSection.execute(args: nil)
        }, completion: { [weak self] result in
            switch result {
            case .success(let settings):
                self?.settings = settings
            case .failure(let error):
                self?.show(error: error)
            }
        })
        worker.execute(task: task)
    }

    fileprivate func getBlogInfoSection(using blogInfo: BlogInfo) -> UITableView.Section {
        let conf = SubtitleTableViewCell.Conf(
            text: blogInfo.blogConf.blogTitle,
            subtitle: blogInfo.user.name,
            image: blogInfo.favicon?.resize(withSize: CGSize(width: 50, height: 50)),
            cornerRadius: 4
        )
        conf.canSelect = false
        conf.accessoryType = .none
        var section = UITableView.Section(id: "BlogInfo", cells: [conf])
        section.header = EmptyTableSectionHeaderConf(height: 20)
        section.footer = EmptyTableSectionFooterConf(height: 20)
        return section
    }

    fileprivate func getInfoSection() -> UITableView.Section {
        let aboutConf = BasicTableViewCell.Conf(
            text: "About",
            image: #imageLiteral(resourceName: "ic_table_info")
        )
        aboutConf.deselect = true
        aboutConf.accessoryType = .disclosureIndicator
        aboutConf.onSelect = openInfo
        let rateConf = BasicTableViewCell.Conf(
            text: "Rate the app",
            image: #imageLiteral(resourceName: "ic_table_rate")
        )
        rateConf.deselect = true
        rateConf.onSelect = openRateApp
        var section = UITableView.Section(id: "Info", cells: [aboutConf, rateConf])
        section.header = EmptyTableSectionHeaderConf(height: 20)
        section.footer = EmptyTableSectionFooterConf(height: 20)
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
        var section = UITableView.Section(id: "SignOut", cells: [conf])
        section.header = EmptyTableSectionHeaderConf(height: 20)
        section.footer = EmptyTableSectionFooterConf(height: 20)
        return section
    }

    private func openInfo() {
        let aboutView = aboutFactory.build()
        open(viewController: aboutView)
    }

    private func openRateApp() {
        openRateAppURLInteractor.execute(args: account)
    }

    private func open(viewController: UIViewController) {
        viewController.hidesBottomBarWhenPushed = true
        view.navigationController?.pushViewController(viewController, animated: true)
    }

    private func signOut() {
        let task = Task(qos: .userInitiated, task: { [weak self] in
            return self?.doSignOutInteractor.execute(args: nil)
        })
        worker.execute(task: task)
    }
}
