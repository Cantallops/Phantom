//
//  AboutView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 23/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AboutView: TableViewController {
    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "About"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
