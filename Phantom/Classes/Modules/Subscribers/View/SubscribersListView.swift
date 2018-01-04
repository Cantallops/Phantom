//
//  SubscribersListView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class SubscribersListView: TableViewController {

    var newSubscriber: (() -> Void)?
    var refreshAction: (() -> Void)?

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "Subscribers"
        tabBarItem.image = #imageLiteral(resourceName: "ic_tab_subscribers")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        navigationItem.title = "Subscribers"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        // FIXME: Uncommnet when develop create subscriber
        /*navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tapAdd)
         )*/
    }

    override func setUpTable() {
        super.setUpTable()
        emptyView = EmptyTableView(
            title: "No subscribers found"
        )
    }

    override func isRefreshable() -> Bool {
        return true
    }

    @objc override func refresh() {
        refreshAction?()
    }

    @objc private func tapAdd() {
        newSubscriber?()
    }
}
