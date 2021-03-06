//
//  TableViewController.swift
//  Phantom
//
//  Created by Alberto Cantallops on 03/01/2018.
//  Copyright © 2018 Alberto Cantallops. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, Presentable {
    var presenter: PresenterProtocol
    var scrollToViewWhenKeyboardShows: Bool = true
    var animatedChanges: Bool = false {
        didSet {
            fullDelegate?.animatedChanges = animatedChanges
        }
    }

    lazy var emptySearchView: UIView? = {
        return EmptyTableView(title: "There are no stories with your search")
    }()
    private var searchController: UISearchController? {
        didSet {
            if #available(iOS 11.0, *) {
                navigationItem.searchController = searchController
            } else {
                searchController?.searchBar.searchBarStyle = .minimal
                tableView.tableHeaderView = searchController?.searchBar
            }
        }

    }
    var searchAction: ((String) -> Void)?
    var searchPlaceholder: String? {
        didSet {
            searchController?.searchBar.placeholder = searchPlaceholder
        }
    }
    var searcheable: Bool = false {
        didSet {
            setUpSearcheable()
        }
    }

    // swiftlint:disable:next weak_delegate
    private var fullDelegate: UITableViewFullDelegate?
    var emptyView: UIView? {
        didSet {
            fullDelegate?.emptyView = emptyView
        }
    }

    var sections: [UITableView.Section] = [] {
        didSet {
            fullDelegate?.sections = sections
            tableView?.refreshControl?.endRefreshing()
        }
    }

    init(presenter: PresenterProtocol) {
        self.presenter = presenter
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented. You must use init(presenter:) instead")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        presenter.didLoad()
        setUpNavigation()
        setUpTable()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        presenter.didLayoutSubviews()
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

    override func present(
        _ viewControllerToPresent: UIViewController,
        animated flag: Bool,
        completion: (() -> Void)? = nil
    ) {
        if viewControllerToPresent == searchController {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        } else if let nav = navigationController {
            nav.present(viewControllerToPresent, animated: flag, completion: completion)
        } else {
            super.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }

    func setUpTable() {
        view.backgroundColor = Color.white
        tableView.separatorStyle = .none
        tableView.backgroundColor = Color.white
        fullDelegate = UITableViewFullDelegate()
        tableView.fullDelegate = fullDelegate
        fullDelegate?.sections = sections
        tableView.tableFooterView = UIView()
        fullDelegate?.emptyView = emptyView
        if isRefreshable() {
            addRefresh()
        }
    }

    func isRefreshable() -> Bool {
        return false
    }

    private func addRefresh() {
        extendedLayoutIncludesOpaqueBars = true
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }

    func setUpNavigation() {

    }

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard)
        )
        tap.delegate = self
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func refresh() {
    }
}

extension TableViewController: UISearchResultsUpdating {

    private func setUpSearcheable() {
        guard searcheable else {
            self.searchController = nil
            return
        }
        let searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        searchController.searchBar.placeholder = searchPlaceholder
        self.searchController = searchController
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        if let emptyView = emptySearchView, !text.isEmpty {
            fullDelegate?.emptyView = emptyView
        } else {
            fullDelegate?.emptyView = emptyView
        }
        searchAction?(text)
    }
}
