//
//  TeamListView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class TeamListView: TableViewController {

    var addAction: (() -> Void)?
    var refreshAction: (() -> Void)?

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "Team"
        tabBarItem.image = #imageLiteral(resourceName: "ic_tab_team")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        navigationItem.title = "Team members"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .always
        }
        // FIXME: Uncommnet when develop create teammember
        /*navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(tapAdd)
        )*/
    }

    override func isRefreshable() -> Bool {
        return true
    }

    @objc private func tapAdd() {
        addAction?()
    }

    @objc override func refresh() {
        refreshAction?()
    }
}
