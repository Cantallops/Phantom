//
//  TabletDashboardPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 09/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class TabletDashboardPresenter: Presenter<TabletDashboardView> {
    private var dashboardSections: [Dashboard.Section] = [] {
        didSet {
            loadSections(dashboard: dashboardSections, settings: settings, blogInfo: blogInfo)
        }
    }
    private var blogInfo: BlogInfo? {
        didSet {
            loadSections(dashboard: dashboardSections, settings: settings, blogInfo: blogInfo)
        }
    }
    private var settings: [UIViewController] = [] {
        didSet {
            loadSections(dashboard: dashboardSections, settings: settings, blogInfo: blogInfo)
        }
    }

    private let getDashboardSections: Interactor<Any?, [Dashboard.Section]>
    private let sessionFactory: Factory<UIViewController>
    private let doSignOutInteractor: Interactor<Any?, Any?>
    private let getCurrentBlogInfo: Interactor<Any?, BlogInfo>
    private let getFavIconImage: Interactor<Any?, UIImage>
    private let getSettingsSection: Interactor<Any?, [UIViewController]>
    private let aboutFactory: Factory<UIViewController>

    private var sections: [Dashboard.Section]?

    init(
        getDashboardSections: Interactor<Any?, [Dashboard.Section]> = GetDashboardSections(),
        sessionFactory: Factory<UIViewController> = SessionFactory(),
        doSignOutInteractor: Interactor<Any?, Any?> = DoSignOut(),
        getCurrentBlogInfo: Interactor<Any?, BlogInfo> = GetCurrentBlogInfo(),
        getFavIconImage: Interactor<Any?, UIImage> = GetFavIconImage(),
        getSettingsSection: Interactor<Any?, [UIViewController]> = GetSettingsSections(),
        aboutFactory: Factory<UIViewController> = AboutFactory()
    ) {
        self.getDashboardSections = getDashboardSections
        self.sessionFactory = sessionFactory
        self.doSignOutInteractor = doSignOutInteractor
        self.getCurrentBlogInfo = getCurrentBlogInfo
        self.getFavIconImage = getFavIconImage
        self.getSettingsSection = getSettingsSection
        self.aboutFactory = aboutFactory
        super.init()
    }

    override func didLoad() {
        super.didLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(signOut),
            name: signOutNotification.name,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(signIn),
            name: signInNotification.name,
            object: nil
        )
    }

    @objc fileprivate func signIn() {
        loadSections()
        loadDashboardSections()
        loadMe()
        loadSettingsSection()
    }

    @objc fileprivate func signOut() {
        let sessionView = sessionFactory.build()
        view.present(sessionView, animated: true)
    }

    fileprivate func loadSections(
        dashboard: [Dashboard.Section] = [],
        settings: [UIViewController] = [],
        blogInfo: BlogInfo? = nil
    ) {
        var sections: [UITableView.Section] = []
        if let blogInfo = blogInfo {
            sections.append(getBlogInfoSection(using: blogInfo))
        }
        if !dashboardSections.isEmpty {
            sections.append(getDashboardSection(using: dashboardSections))
        }
        if !settings.isEmpty {
            sections.append(getSettingSection(from: settings))
        }
        sections.append(getInfoSection())
        sections.append(getLogOutSection())
        view.sections = sections
    }

    private func loadDashboardSections() {
        async(background: { [unowned self] in
            return self.getDashboardSections.execute(args: nil)
            }, main: { [unowned self] result in
                switch result {
                case .success(let sections):
                    self.dashboardSections = sections
                case .failure(let error): self.show(error: error)
                }
        })
    }

    fileprivate func loadMe() {
        async(background: { [unowned self] in
            return self.getCurrentBlogInfo.execute(args: nil)
            }, main: { [weak self] result in
                switch result {
                case .success(let blogInfo):
                    self?.blogInfo = blogInfo
                case .failure(let error):
                    self?.show(error: error)
                }
        })
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

    private func getDashboardSection(using sections: [Dashboard.Section]) -> UITableView.Section {
        var cells: [TableCellConf] = []
        for section in sections {
            let conf = BasicTableViewCell.Conf(
                text: section.name,
                image: section.icon
            )
            let view = NavigationController(rootViewController: section.factory.build())
            conf.onSelect = { [weak self] in
                self?.open(viewController: view)
            }
            cells.append(conf)
        }
        cells.first?.initialySelected = true
        cells.first?.onSelect?()
        var section = UITableView.Section(cells: cells)
        section.header = EmptyTableSectionHeader(height: 10)
        section.footer = EmptyTableSectionFooter(height: 20)
        return section
    }

    fileprivate func getSettingSection(from settings: [UIViewController]) -> UITableView.Section {
        var cells: [TableCellConf] = []
        for setting in settings {
            let conf = BasicTableViewCell.Conf(
                text: setting.title,
                image: setting.tabBarItem.image
            )
            let view = NavigationController(rootViewController: setting)
            conf.onSelect = { [weak self] in
                self?.open(viewController: view)
            }
            cells.append(conf)
        }
        var section = UITableView.Section(cells: cells)
        let header = SimpleTableSectionHeader(title: "Settings")
        header.customView.backgroundColor = Color.lighterGrey
        section.header = header
        section.footer = EmptyTableSectionFooter(height: 20)
        return section
    }

    fileprivate func getBlogInfoSection(using blogInfo: BlogInfo) -> UITableView.Section {
        let conf = SubtitleTableViewCell.Conf(
            text: blogInfo.blogConf.blogTitle,
            subtitle: blogInfo.user.name,
            image: blogInfo.favicon?.resize(withSize: CGSize(width: 50, height: 50))
        )
        conf.canSelect = false
        var section = UITableView.Section(cells: [conf])
        section.header = EmptyTableSectionHeader(height: 20)
        section.footer = EmptyTableSectionFooter(height: 20)
        return section
    }

    fileprivate func getInfoSection() -> UITableView.Section {
        let conf = BasicTableViewCell.Conf(
            text: "About",
            image: #imageLiteral(resourceName: "ic_table_info")
        )
        conf.deselect = false
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
        open(viewController: NavigationController(rootViewController: aboutView))
    }

    private func open(viewController: UIViewController) {
        view.detailView = viewController
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
