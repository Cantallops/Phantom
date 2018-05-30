//
//  MetaDataView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 22/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class MetaDataView: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.lighterGrey
    }

    override func setUpNavigation() {
        navigationItem.title = "Meta Data"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
            navigationItem.largeTitleDisplayMode = .never
        }
    }

}
