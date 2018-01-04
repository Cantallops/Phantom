//
//  StoriesListView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class StoriesListView: TableViewController {

    var newStoryAction: (() -> Void)?
    var refreshAction: (() -> Void)?

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "Content"
        tabBarItem.image = #imageLiteral(resourceName: "ic_tab_stories")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        navigationItem.title = "Your stories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_nav_compose").withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(tapAdd)
        )
    }

    override func setUpTable() {
        super.setUpTable()
        emptyView = EmptyButtonTableView(
            title: "You haven't written any stories yet!",
            buttonTitle: "Write a new story",
            buttonAction: tapAdd
        )
    }

    override func isRefreshable() -> Bool {
        return true
    }

    @objc private func tapAdd() {
        newStoryAction?()
    }

    @objc override func refresh() {
        refreshAction?()
    }
}
