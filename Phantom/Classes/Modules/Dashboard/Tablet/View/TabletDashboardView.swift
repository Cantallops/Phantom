//
//  TabletDashboardView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 09/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class TabletDashboardView: UISplitViewController {

    let presenter: Presenter<TabletDashboardView>
    private var sideView: TableViewController! {
        didSet {
            sideView.tableView.bounces = false
            sideView.clearsSelectionOnViewWillAppear = false
            sideView.tableView.backgroundColor = Color.lighterGrey
        }
    }
    var detailView: UIViewController! {
        didSet {
            showDetailViewController(detailView, sender: nil)
        }
    }

    var sections: [UITableView.Section] = [] {
        didSet {
            sideView.sections = sections
        }
    }

    init(presenter: Presenter<TabletDashboardView>) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad()
        setUpUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.willAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.didAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.willDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.didDisappear()
    }

    fileprivate func setUpUI() {
        delegate = self
        maximumPrimaryColumnWidth = 280
        view.backgroundColor = Color.white
        sideView = TableViewController(presenter: self)
        viewControllers = [sideView, UITableViewController()]
        preferredDisplayMode = .allVisible
    }

}

extension TabletDashboardView: UISplitViewControllerDelegate {
}

extension TabletDashboardView: PresenterProtocol {
    func didLoad() {
    }

    func didLayoutSubviews() {
    }

    func willAppear() {
    }

    func didAppear() {
    }

    func willDisappear() {
    }

    func didDisappear() {
    }
}
