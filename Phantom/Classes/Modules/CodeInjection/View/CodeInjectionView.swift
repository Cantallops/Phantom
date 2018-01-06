//
//  CodeInjectionView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 07/10/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class CodeInjectionView: ViewController {

    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "Code Injection"
        tabBarItem.image = #imageLiteral(resourceName: "ic_table_code_injection")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setUpNavigation() {
        super.setUpNavigation()
        navigationItem.title = "Code Injection"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

}
