//
//  LabsView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class LabsView: ViewController {

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "Labs"
        tabBarItem.image = #imageLiteral(resourceName: "ic_table_labs")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        navigationItem.title = "Labs"
        navigationItem.largeTitleDisplayMode = .never
    }

}
