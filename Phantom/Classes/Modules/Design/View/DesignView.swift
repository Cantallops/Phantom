//
//  DesignView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class DesignView: ViewController {

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "Design"
        tabBarItem.image = #imageLiteral(resourceName: "ic_table_design")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        navigationItem.title = "Design"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

}
