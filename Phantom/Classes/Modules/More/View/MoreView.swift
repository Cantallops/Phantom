//
//  MoreView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 05/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class MoreView: TableViewController {

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "More"
        tabBarItem.image = #imageLiteral(resourceName: "ic_tab_more")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        navigationItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.largeTitleDisplayMode = .never
    }

}
