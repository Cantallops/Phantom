//
//  TagsListView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TagsListView: TableViewController {

    var device: UIDevice = .current
    var addTagAction: (() -> Void)?
    var refreshAction: (() -> Void)?

    override init(
        presenter: PresenterProtocol
    ) {
        super.init(presenter: presenter)
        title = "Tags"
        tabBarItem.image = #imageLiteral(resourceName: "ic_table_tags")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        navigationItem.title = "Tags"
        if #available(iOS 11.0, *), device.isPad {
            navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tapAdd)
        )
    }

    override func setUpTable() {
        super.setUpTable()
        emptyView = EmptyButtonTableView(
            title: "You haven't added any tags yet!",
            buttonTitle: "Add a tag",
            buttonAction: tapAdd
        )
    }

    override func isRefreshable() -> Bool {
        return true
    }

    @objc private func tapAdd() {
        addTagAction?()
    }

    @objc override func refresh() {
        refreshAction?()
    }
}
