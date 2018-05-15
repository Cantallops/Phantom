//
//  TabletDashboardPresenter.swift
//  Phantom
//
//  Created by Alberto Cantallops on 09/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class TabletDashboardPresenter: Presenter<TabletDashboardView> {

    private var observers: [NSObjectProtocol] = []
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

    private let worker: Worker
    private let account: Account?
    private let getDashboardSections: Interactor<Any?, [Dashboard.Section]>
    private let sessionFactory: Factory<UIViewController>
    private let doSignOutInteractor: Interactor<Any?, Any?>
    private let getCurrentBlogInfo: Interactor<Any?, BlogInfo>
    private let getFavIconImage: Interactor<Any?, UIImage>
    private let getSettingsSection: Interactor<Any?, [UIViewController]>
    private let aboutFactory: Factory<UIViewController>
    private let openRateAppURLInteractor: Interactor<Account?, Any?>

    private var sections: [Dashboard.Section]?

    init(
        worker: Worker = AsyncWorker(),
        account: Account?,
        getDashboardSections: Interactor<Any?, [Dashboard.Section]> = GetDashboardSectionsInteractor(),
        sessionFactory: Factory<UIViewController> = SessionFactory(),
        doSignOutInteractor: Interactor<Any?, Any?> = DoSignOutInteractor(),
        getCurrentBlogInfo: Interactor<Any?, BlogInfo> = GetCurrentBlogInfoInteractor(),
        getFavIconImage: Interactor<Any?, UIImage> = GetFavIconImageInteractor(),
        getSettingsSection: Interactor<Any?, [UIViewController]> = GetSettingsSections(),
        aboutFactory: Factory<UIViewController> = AboutFactory(),
        openRateAppURLInteractor: Interactor<Account?, Any?> = OpenRateAppURLInteractor()
    ) {
        self.worker = worker
        self.account = account
        self.getDashboardSections = getDashboardSections
        self.sessionFactory = sessionFactory
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
        let signOutObserver = sessionNotificationCenter.addObserver(forType: .signOut) { [weak self] _ in
            self?.signOut()
        }
        let signInObserver = sessionNotificationCenter.addObserver(forType: .signIn) { [weak self] _ in
            self?.signIn()
        }
        observers = [signOutObserver, signInObserver]
    }

    fileprivate func signIn() {
        loadSections()
        loadDashboardSections()
        loadMe()
        loadSettingsSection()
    }

    fileprivate func signOut() {
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
        let task = Task(task: { [unowned self] in
            return self.getDashboardSections.execute(args: nil)
        }, completion: { [unowned self] result in
            switch result {
            case .success(let sections):
                self.dashboardSections = sections
            case .failure(let error): self.show(error: error)
            }
        })
        worker.execute(task: task)
    }

    fileprivate func loadMe() {
        let task = Task(task: { [unowned self] in
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
        let task = Task(task: { [unowned self] in
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
        var section = UITableView.Section(id: "Dashboard", cells: cells)
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
        var section = UITableView.Section(id: "Settings", cells: cells)
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
        var section = UITableView.Section(id: "BlogInfo", cells: [conf])
        section.header = EmptyTableSectionHeader(height: 20)
        section.footer = EmptyTableSectionFooter(height: 20)
        return section
    }

    fileprivate func getInfoSection() -> UITableView.Section {
        let aboutConf = BasicTableViewCell.Conf(
            text: "About",
            image: #imageLiteral(resourceName: "ic_table_info")
        )
        aboutConf.onSelect = openInfo
        let rateConf = BasicTableViewCell.Conf(
            text: "Rate the app",
            image: #imageLiteral(resourceName: "ic_table_rate")
        )
        rateConf.deselect = true
        rateConf.onSelect = openRateApp
        var section = UITableView.Section(id: "Info", cells: [aboutConf, rateConf])
        section.header = EmptyTableSectionHeader(height: 20)
        section.footer = EmptyTableSectionFooter(height: 20)
        return section
    }

    private func openRateApp() {
        openRateAppURLInteractor.execute(args: account)
    }

    fileprivate func getLogOutSection() -> UITableView.Section {
        let conf = BasicTableViewCell.Conf(
            text: "Sign Out",
            image: #imageLiteral(resourceName: "ic_table_signout")
        )
        conf.deselect = true
        conf.onSelect = signOut
        var section = UITableView.Section(id: "SignOut", cells: [conf])
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
        for observer in observers {
            sessionNotificationCenter.remove(observer: observer)
        }
        observers.removeAll()
    }
}
